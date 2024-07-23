resource "aws_acmpca_certificate_authority" "ca" {
  type               = "ROOT"
  certificate_authority_configuration {
    key_algorithm    = "RSA_2048"
    signing_algorithm = "SHA256WITHRSA"
    subject {
      common_name   = "pedroform.com"
      organization  = "Hashicorp"
      organizational_unit = "Pedroform"
      country       = "US"
      state         = "California"
      locality      = "San Francisco"
    }
  }
  permanent_deletion_time_in_days = 7
  enabled = true
}

resource "aws_acmpca_certificate" "example" {
  certificate_authority_arn = aws_acmpca_certificate_authority.ca.arn
  certificate_signing_request = aws_acmpca_certificate_authority.ca.certificate_signing_request
  signing_algorithm = "SHA256WITHRSA"
  validity {
    type = "YEARS"
    value = 1
  }
}

output "certificate_arn" {
  value = aws_acmpca_certificate.example.arn
}