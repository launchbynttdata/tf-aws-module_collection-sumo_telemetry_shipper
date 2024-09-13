package testimpl

import (
	"context"
	"strings"
	"testing"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/cloudwatchlogs"
	"github.com/aws/aws-sdk-go-v2/service/cloudwatch"
	"github.com/aws/aws-sdk-go-v2/service/firehose"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestSumoTelemetryShipperComplete(t *testing.T, ctx types.TestContext) {
	t.Run("TestARNPatternMatches", func(t *testing.T) {
		checkARNFormat(t, ctx)
	})

	t.Run("TestingLogGroup", func(t *testing.T) {
		checkLogGroup(t, ctx)
	})

	t.Run("TestingLogStream", func(t *testing.T){
		checkLogStream(t, ctx)
	})

	t.Run("TestingMetricStream", func(t *testing.T){
		checkMetricStream(t, ctx)
	})

	t.Run("TestingLogsDeliveryStream", func(t *testing.T){
		checkDeliveryStream(t, ctx, "logs")
	})

	t.Run("TestingMetricsDeliveryStream", func(t *testing.T){
		checkDeliveryStream(t, ctx, "metrics")
	})
}

func checkARNFormat(t *testing.T, ctx types.TestContext) {
	expectedLogGroupPatternARN := "^arn:aws:logs:[a-z0-9-]+:[0-9]{12}:log-group:[a-zA-Z0-9-]+$"
	expectedLogStreamPatternARN := "^arn:aws:logs:[a-z0-9-]+:[0-9]{12}:log-group:[a-zA-Z0-9-]+:log-stream:[a-zA-Z0-9-]+$"
	expectedMetricStreamPatternARN := "^arn:aws:cloudwatch:[a-z0-9-]+:[0-9]{12}:[a-z0-9-]+/.+$"
	expectedFirehoseStreamPatternARN := "^arn:aws:firehose:[a-z0-9-]+:[0-9]{12}:[a-z0-9-]+/.+$"

	actualLogGroupARN := terraform.Output(t, ctx.TerratestTerraformOptions(), "cloudwatch_log_group_arn")
	assert.NotEmpty(t, actualLogGroupARN, "Log Group ARN is empty")
	assert.Regexp(t, expectedLogGroupPatternARN, strings.Trim(actualLogGroupARN, "[]"), "Log Group ARN does not match expected pattern")

	actualLogStreamARN := terraform.Output(t, ctx.TerratestTerraformOptions(), "cloudwatch_log_stream_arn")
	assert.NotEmpty(t, actualLogStreamARN, "Log Stream ARN is empty")
	assert.Regexp(t, expectedLogStreamPatternARN, strings.Trim(actualLogStreamARN, "[]"), "Log Stream ARN does not match expected pattern")

	actualMetricStreamARN := terraform.Output(t, ctx.TerratestTerraformOptions(), "cloudwatch_metric_stream_arn")
	assert.NotEmpty(t, actualMetricStreamARN, "Metric Stream ARN is empty")
	assert.Regexp(t, expectedMetricStreamPatternARN, actualMetricStreamARN, "Metric Stream ARN does not match expected pattern")

	actualLogDeliveryStreamARN := terraform.Output(t, ctx.TerratestTerraformOptions(), "logs_delivery_stream_arn")
	assert.NotEmpty(t, actualLogDeliveryStreamARN, "Log Delivery Stream ARN is empty")
	assert.Regexp(t, expectedFirehoseStreamPatternARN, actualLogDeliveryStreamARN, "Log Delivery Stream ARN does not match expected pattern")

	actualMetricDeliveryStreamARN := terraform.Output(t, ctx.TerratestTerraformOptions(), "metrics_delivery_stream_arn")
	assert.NotEmpty(t, actualMetricDeliveryStreamARN, "Metric Delivery Stream ARN is empty")
	assert.Regexp(t, expectedFirehoseStreamPatternARN, actualMetricDeliveryStreamARN, "Metric Delivery Stream ARN does not match expected pattern")
}

func checkLogGroup(t *testing.T, ctx types.TestContext) {
	client := GetCloudWatchLogClient(t)
	expectedName := terraform.Output(t, ctx.TerratestTerraformOptions(), "cloudwatch_log_group_name")

	input := &cloudwatchlogs.DescribeLogGroupsInput{
		LogGroupNamePrefix: aws.String(strings.Trim(expectedName, "[]")),
	}

	output, err := client.DescribeLogGroups(context.TODO(), input)
	assert.NoError(t, err, "Failed to retrieve log group from AWS")

	currentName := output.LogGroups[0].LogGroupName
	assert.Equal(t, strings.Trim(expectedName, "[]"), *currentName, "Log group name doesn't match")
}

func checkLogStream(t *testing.T, ctx types.TestContext) {
	client := GetCloudWatchLogClient(t)
	groupName := terraform.Output(t, ctx.TerratestTerraformOptions(), "cloudwatch_log_group_name")
	expectedName := terraform.Output(t, ctx.TerratestTerraformOptions(), "cloudwatch_log_stream_name")

	input := &cloudwatchlogs.DescribeLogStreamsInput{
		LogGroupName: aws.String(strings.Trim(groupName, "[]")),
	}

	output, err := client.DescribeLogStreams(context.TODO(), input)
	assert.NoError(t, err, "Failed to retrieve log stream from AWS")

	currentName := *output.LogStreams[0].LogStreamName
	assert.Equal(t, strings.Trim(expectedName, "[]"), currentName, "Log stream name doesn't match")
}

func checkMetricStream(t *testing.T, ctx types.TestContext) {
	client := GetCloudWatchClient(t)
	expectedName := terraform.Output(t, ctx.TerratestTerraformOptions(), "cloudwatch_metric_stream_name")

	input := &cloudwatch.GetMetricStreamInput{
		Name: aws.String(expectedName),
	}

	result, err := client.GetMetricStream(context.TODO(), input)
	assert.NoError(t, err, "Failed to retrieve metric stream from AWS")

	currentName := result.Name
	assert.Equal(t, expectedName, *currentName, "Metric stream name doesn't match")
}

func checkDeliveryStream(t *testing.T, ctx types.TestContext, streamType string) {
	client := GetFireHoseClient(t)
	expectedDeliveryStreamId := terraform.Output(t, ctx.TerratestTerraformOptions(), streamType+"_delivery_stream_destination_id")
	expectedDeliveryStreamName := terraform.Output(t, ctx.TerratestTerraformOptions(), streamType+"_delivery_stream_name")

	input := &firehose.DescribeDeliveryStreamInput{
		DeliveryStreamName:          aws.String(expectedDeliveryStreamName),
		ExclusiveStartDestinationId: aws.String(expectedDeliveryStreamId),
		Limit:                       aws.Int32(5),
	}

	result, err := client.DescribeDeliveryStream(context.TODO(), input)
	assert.NoError(t, err, "Failed to describe "+streamType+" Delivery Stream from AWS")

	actualDeliveryStream := result.DeliveryStreamDescription.DeliveryStreamName
	assert.Equal(t, expectedDeliveryStreamName, *actualDeliveryStream, streamType+" Delivery Stream name doesn't match")
}

func GetAWSConfig(t *testing.T) (cfg aws.Config) {
	cfg, err := config.LoadDefaultConfig(context.TODO())
	require.NoErrorf(t, err, "unable to load SDK config, %v", err)
	return cfg
}

func GetCloudWatchLogClient(t *testing.T) *cloudwatchlogs.Client {
	cloudwatchlogClient := cloudwatchlogs.NewFromConfig(GetAWSConfig(t))
	return cloudwatchlogClient
}

func GetCloudWatchClient(t *testing.T) *cloudwatch.Client {
	cloudwatchClient := cloudwatch.NewFromConfig(GetAWSConfig(t))
	return cloudwatchClient
}

func GetFireHoseClient(t *testing.T) *firehose.Client {
	fireHoseClient := firehose.NewFromConfig(GetAWSConfig(t))
	return fireHoseClient
}
