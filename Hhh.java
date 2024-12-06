import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.saml2.provider.service.registration.RelyingPartyRegistration;
import org.springframework.security.saml2.provider.service.registration.InMemoryRelyingPartyRegistrationRepository;
import org.springframework.security.saml2.provider.service.registration.RelyingPartyRegistrationRepository;
import org.springframework.security.saml2.credentials.Saml2X509Credential;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.nio.file.Files;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;
import java.util.Collections;

@Configuration
public class RelyingPartyConfig {

    @Bean
    public RelyingPartyRegistrationRepository relyingPartyRegistrationRepository() throws Exception {
        // IdP Certificate from idp_metadata.xml
        String idpCertificate = """
            -----BEGIN CERTIFICATE-----
            MIID... (Your Certificate Here)
            -----END CERTIFICATE-----
        """;

        // Parse IdP Certificate
        CertificateFactory certFactory = CertificateFactory.getInstance("X.509");
        X509Certificate certificate = (X509Certificate) certFactory.generateCertificate(
                new ByteArrayInputStream(idpCertificate.getBytes())
        );

        // Verification Credential
        Saml2X509Credential verificationCredential = Saml2X509Credential.verification(certificate);

        // Relying Party Registration
        RelyingPartyRegistration relyingPartyRegistration = RelyingPartyRegistration
                .withRegistrationId("acint-idp")
                .entityId("http://localhost:8080/acint/saml/sp")
                .assertionConsumerServiceLocation("http://localhost:8080/acint/saml/SSO")
                .assertingPartyDetails(party -> party
                        .entityId("https://intra.usignon.int.cm.par.emea.cib/2025_ECH_Acint")
                        .singleSignOnServiceLocation("https://intra.usignon.int.cm.par.emea.cib/2025_ECH_Acint/sso")
                        .verificationX509Credentials(Collections.singletonList(verificationCredential))
                )
                .build();

        return new InMemoryRelyingPartyRegistrationRepository(relyingPartyRegistration);
    }
}
