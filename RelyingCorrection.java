package com.example.security;

import org.springframework.core.io.ClassPathResource;
import org.springframework.security.saml2.core.Saml2X509Credential;
import org.springframework.security.saml2.provider.service.registration.AssertingPartyDetails;
import org.springframework.security.saml2.provider.service.registration.RelyingPartyRegistration;

import java.io.InputStream;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;

public class RelyingPartyRegistrationConfig {

    public static RelyingPartyRegistration buildRelyingPartyRegistration() {
        try {
            // Load IdP Certificate
            InputStream certStream = new ClassPathResource("idp-certificate.pem").getInputStream();
            CertificateFactory factory = CertificateFactory.getInstance("X.509");
            X509Certificate idpCertificate = (X509Certificate) factory.generateCertificate(certStream);

            // Define credentials
            Saml2X509Credential verificationCredential = Saml2X509Credential.verification(idpCertificate);

            return RelyingPartyRegistration
                .withRegistrationId("acint-idp")
                .entityId("http://localhost:8080/acint/saml/sp")
                .assertionConsumerServiceLocation("http://localhost:8080/acint/saml/SSO/alias/acint.local")
                .assertingPartyDetails(details -> details
                    .entityId("https://intra.usignon.int.cm.par.emea.cib/2025_ECH_Acint")
                    .singleSignOnServiceLocation("https://intra.usignon.int.cm.par.emea.cib/SSOService")
                    .verificationX509Credentials(c -> c.add(verificationCredential))
                )
                .build();

        } catch (Exception e) {
            throw new RuntimeException("Error loading SAML configuration", e);
        }
    }
}
