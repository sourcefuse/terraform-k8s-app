package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformExample(t *testing.T) {
	// Arrange
	terraformOptions := &terraform.Options{
		TerraformDir: "../example/.",
	}
	defer terraform.Destroy(t, terraformOptions)

	// Act
	terraform.InitAndApply(t, terraformOptions)

	// Assert
	assert := assert.New(t)

  kubernetesServiceNameOutputValue := terraform.Output(t, terraformOptions, "kubernetes_service_name")
  assert.NotNil(kubernetesServiceNameOutputValue)
  assert.Equal("nginx", kubernetesServiceNameOutputValue)

  kubernetesServicePortOutputValue := terraform.Output(t, terraformOptions, "kubernetes_service_port")
  assert.NotNil(kubernetesServicePortOutputValue)
  assert.Equal("80", kubernetesServicePortOutputValue)

  kubernetesHostOutputValue := terraform.Output(t, terraformOptions, "kubernetes_host")
  assert.NotNil(kubernetesHostOutputValue)
  assert.Equal("nginx.terratest.svc.cluster.local", kubernetesHostOutputValue)

  kubernetesNamespaceOutputValue := terraform.Output(t, terraformOptions, "kubernetes_namespace")
  assert.NotNil(kubernetesNamespaceOutputValue)
  assert.Equal("terratest", kubernetesNamespaceOutputValue)
}
