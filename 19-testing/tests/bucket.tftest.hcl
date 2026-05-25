# mock_provider: giả lập AWS -> test chạy KHÔNG tạo hạ tầng thật, không cần credential.
mock_provider "aws" {}

# Test 1: tên bucket được ghép đúng từ project + environment.
run "bucket_name_is_composed" {
  command = plan

  variables {
    project     = "tf-series"
    environment = "dev"
  }

  assert {
    condition     = aws_s3_bucket.data.bucket == "tf-series-dev-data"
    error_message = "Tên bucket ghép sai: ${aws_s3_bucket.data.bucket}"
  }
}

# Test 2: tag Environment khớp biến đầu vào.
run "tag_matches_env" {
  command = plan

  variables {
    project     = "tf-series"
    environment = "prod"
  }

  assert {
    condition     = aws_s3_bucket.data.tags["Environment"] == "prod"
    error_message = "Tag Environment không khớp."
  }
}

# Test 3: environment sai phải bị validation chặn (expect_failures).
run "invalid_env_rejected" {
  command = plan

  variables {
    project     = "tf-series"
    environment = "production" # sai -> phải fail validation
  }

  expect_failures = [var.environment]
}
