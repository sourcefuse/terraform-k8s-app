#!/bin/bash

### terraform testing
go get github.com/gruntwork-io/terratest/modules/terraform
go get github.com/gruntwork-io/terratest/modules/k8s
go get github.com/stretchr/testify/assert

## kubernets testing
go get testing
go get fmt

go test
