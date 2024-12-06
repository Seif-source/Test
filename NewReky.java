package com.example.saml.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.saml2.provider.service.registration.InMemoryRelyingPartyRegistrationRepository;
import org.springframework.security.saml2.provider.service.registration.RelyingPartyRegistration;
import org.springframework.security.saml2.provider.service.registration.RelyingPartyRegistrationRepository;
import org.springframework.security.saml2.credentials.Saml2X509Credential;

import org.w3c.dom.Document;
import org.w3c.dom.NodeList;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;
import java.util.Base64;

@Configuration
public class SamlConfig {

    @Bean
    public RelyingPartyRegistrationRepository relyingPartyRegistrationRepository() {
        // SP and IdP configuration
        String spEntityId = "http://localhost:8080/saml2/service-provider-metadata/acint.local";
        String assertionConsumerServiceLocation = "http://localhost:8080/saml2/authenticate";
        String idpEntityId = "https://intra.usignon.int.cm.par.emea.cib/2025_ECH_Acint";
        String idpMetadataPath = "path/to/idp_metadata.xml"; // Path to IdP metadata XML file

        // Load IdP certificate from metadata
        Saml2X509Credential verificationCredential = Saml2X509Credential.verification(loadCertificateFromMetadata(idpMetadataPath));

        // Configure relying party registration
        RelyingPartyRegistration registration = RelyingPartyRegistration.withRegistrationId("acint-idp")
                .entityId(spEntityId) // SP Entity ID
                .assertionConsumerServiceLocation(assertionConsumerServiceLocation) // ACS URL
                .assertingPartyDetails(details -> details
                        .entityId(idpEntityId) // IdP Entity ID
                        .verificationX509Credentials(c -> c.add(verificationCredential)) // Add IdP certificate for verification
                )
                .build();

        return new InMemoryRelyingPartyRegistrationRepository(registration);
    }

    private X509Certificate loadCertificateFromMetadata(String metadataFilePath) {
        try (InputStream inputStream = new FileInputStream(new File(metadataFilePath))) {
            // Parse the metadata XML
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            factory.setNamespaceAware(true);
            DocumentBuilder builder = factory.newDocumentBuilder();
            Document document = builder.parse(inputStream);

            // Find the <X509Certificate> element in the metadata
            NodeList nodeList = document.getElementsByTagNameNS("http://www.w3.org/2000/09/xmldsig#", "X509Certificate");
            if (nodeList.getLength() == 0) {
                throw new IllegalArgumentException("No X509Certificate found in the IdP metadata file.");
            }

            // Decode the base64-encoded certificate
            String base64Cert = nodeList.item(0).getTextContent().replaceAll("\\s+", "");
            byte[] decodedCert = Base64.getDecoder().decode(base64Cert);

            // Convert the certificate to X509 format
            CertificateFactory certificateFactory = CertificateFactory.getInstance("X.509");
            return (X509Certificate) certificateFactory.generateCertificate(new ByteArrayInputStream(decodedCert));
        } catch (Exception e) {
            throw new RuntimeException("Failed to load IdP certificate from metadata file", e);
        }
    }
}
