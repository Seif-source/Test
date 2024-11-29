package com.ca.cib.acint.ihm.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.saml2.core.Saml2X509Credential;
import org.springframework.security.saml2.provider.service.registration.InMemoryRelyingPartyRegistrationRepository;
import org.springframework.security.saml2.provider.service.registration.RelyingPartyRegistration;
import org.springframework.security.saml2.provider.service.registration.RelyingPartyRegistrationRepository;
import org.springframework.security.saml2.provider.service.registration.Saml2MessageBinding;

import java.io.ByteArrayInputStream;
import java.io.FileInputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;
import java.security.spec.PKCS8EncodedKeySpec;
import java.util.Base64;

@Configuration
public class RelyingPartyConfig {

    @Bean
    public RelyingPartyRegistrationRepository relyingPartyRegistrationRepository()  {
        // Configuration du Service Provider (SP)
        String spEntityId = "acint.local"; // ID de l'entité du SP, tiré de sp_metadata.xml
        String assertionConsumerServiceLocation = "http://localhost:8080/acint/saml/SSO/alias/acint.local";

        // Configuration de l'Identity Provider (IdP)
        String idpEntityId = "https://intra.usignon.int.cm.par.emea.cib/2025_ECH_Acint"; // Tiré de idp_metadata.xml
        String singleSignOnServiceLocation = "https://intra.usignon.int.cm.par.emea.cib/samlv2/AccueilAuth/IdPAccess/2025_ECH_Acint";
        String singleLogoutServiceLocation = "https://intra.usignon.int.cm.par.emea.cib/samlv2/SLOIdP/2025_ECH_Acint";


        RelyingPartyRegistration relyingPartyRegistration = RelyingPartyRegistration
                .withRegistrationId("/test")
                .assertingPartyMetadata(assertingParty -> assertingParty
                        .entityId(idpEntityId)
                        .singleSignOnServiceLocation(singleSignOnServiceLocation)
                        .singleLogoutServiceLocation(singleLogoutServiceLocation)
                        .singleSignOnServiceBinding(Saml2MessageBinding.POST)
                        .verificationX509Credentials(c -> {
                            try {
                                c.add(verifyingCredential());
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        }) // Certificat IdP
                )
                .entityId(spEntityId) // SP Entity ID
                .assertionConsumerServiceLocation(assertionConsumerServiceLocation) // SP Assertion Consumer Service URL
                .signingX509Credentials(c -> {
                    try {
                        c.add(signingCredential());
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }) // Certificat SP
                .build();

        return new InMemoryRelyingPartyRegistrationRepository(relyingPartyRegistration);
    }


    private Saml2X509Credential verifyingCredential() throws Exception {
        // Chemin du fichier PEM contenant le certificat public de l'IdP
        String certFilePath = "C:\\Users\\ut3sr8\\My_IT_Applications\\IdeaProjects\\ech\\acint-ui-service\\src\\main\\resources\\idp-certificate.pem";

        // Charger le certificat à partir du fichier
        try (FileInputStream fis = new FileInputStream(certFilePath)) {
            CertificateFactory certFactory = CertificateFactory.getInstance("X.509");
            X509Certificate certificate = (X509Certificate) certFactory.generateCertificate(fis);

            // Retourner le credential de vérification
            return Saml2X509Credential.verification(certificate);
        }
    }

    private Saml2X509Credential signingCredential() throws Exception {
        // Charger la clé privée et le certificat public du SP
        String privateKeyContent = Files.readString(Paths.get("C:\\Users\\ut3sr8\\My_IT_Applications\\IdeaProjects\\ech\\acint-ui-service\\src\\main\\resources\\sp-private-key.pem"));

        byte[] keyBytes = Base64.getDecoder().decode(privateKeyContent);
        java.security.KeyFactory keyFactory = java.security.KeyFactory.getInstance("RSA");
        java.security.PrivateKey privateKey = keyFactory.generatePrivate(new PKCS8EncodedKeySpec(keyBytes));

        String cert = "-----BEGIN CERTIFICATE-----\nMIIFWTCCBEGgAwIBAgINALkNEXK3IestJoU0lDANBgkqhkiG9w0BAQsFADCBhjELMAkGA1UEBhMCRlIxHjAcBgNVBAoMFUNyZWRpdCBBZ3JpY29sZSBHcm91cDEaMBgGA1UECwwRUHJpdmF0ZSBHcm91cCBQS0kxFzAVBgNVBAsMDjAwMDIgNzg0NjA4NDE2MSIwIAYDVQQDDBlDQSBDcmVkaXQgQWdyaWNvbGUgU2VydmVyMB4XDTIwMDcwNjEyMDYyOFoXDTI1MDcwNTEyMDcyOFowgYwxCzAJBgNVBAYTAkZSMR4wHAYDVQQKDBVDcmVkaXQgQWdyaWNvbGUgR3JvdXAxGjAYBgNVBAsMEVByaXZhdGUgR3JvdXAgUEtJMQ4wDAYDVQQLDAVDQUNJQjEOMAwGA1UECwwFMTQwMDAxITAfBgNVBAMMGGlkcC51c2lnbm9uLmludC5lbWVhLmNpYjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAM0rOx+Ib5vRi7hbuFqw+bTabY3Kdz/D6orH7V4iCXCqRgDk23VsVOAcNZT+0lhktmOiVDJXEzLzYQFy01mJAK31v8xz0HTwcTBRO4ArsD6ULke0RulMmYVLQUpeWlmhGvt2nHAwXPyqLJUjF3s+W0p486VEIuX+1zrzDPXSi096KihQaN9tPp90BNPprqs89tES3CetWr0sf+zb6iCAOxyOMUAF0Fgtfq22RSqu4579guyVmNJrilYiXYZDO2+avRIW+DP+2v+xLo0XAzPZNHbFc4MzRsEtRn3RvZhizlIal5yC7usv72/HWba0s1A29oDw6s0+DwnpdiYXa+5qrdUCAwEAAaOCAbwwggG4MB0GA1UdDgQWBBQs7KVdg6NtkM+2sFAFEEVYxeBTODAfBgNVHSMEGDAWgBSU+Xpry0+XY2GBBSNqyBkvvgt57DAXBgNVHSAEEDAOMAwGCiqBegGCPAEBBgEwHQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMBMA4GA1UdDwEB/wQEAwIFoDAjBgNVHREEHDAaghhpZHAudXNpZ25vbi5pbnQuZW1lYS5jaWIwVgYDVR0fBE8wTTBLoEmgR4ZFaHR0cDovL2NybC1wcml2LXBraS5jcmVkaXQtYWdyaWNvbGUuZnIvY3JsL0NBQ3JlZGl0QWdyaWNvbGVTZXJ2ZXIuY3JsMIGwBggrBgEFBQcBAQSBozCBoDBdBggrBgEFBQcwAoZRaHR0cDovL2NhaXNzdWVycy1wcml2LXBraS5jcmVkaXQtYWdyaWNvbGUuZnIvY2Fpc3N1ZXJzL0NBQ3JlZGl0QWdyaWNvbGVTZXJ2ZXIucDdjMD8GCCsGAQUFBzABhjNodHRwOi8vb2NzcC1wcml2LXBraS5jcmVkaXQtYWdyaWNvbGUuZnIvb2NzcC9zZXJ2ZXIwDQYJKoZIhvcNAQELBQADggEBAPCSCx2WBS+sHKJa3FPd0QSeb4WChf9Q7PUDornqWIBWMJ+RRYMfpFjzaJ5nGy1c+EbEf3V4Gbfzz0OxJkFpr3S+OqAeO7qCbFTpDfrKJCNMLdHLnMCKydVteHzmMKT+DoqjMRsRyOpP+2lC1zXb59prmSnzKRKWWDHwsvLYWGgvk4VzEQv+cqrvQlgr030CBnJoioTLlKP5XGNzvu9Hkm6DwNkS/Zhi918+DINXHj8jpoKbVJru5Ho9J9T2rm2la5G44iORKO+qZQGSNAl3jilkr6WJNv3Q4+ENsNyIUt21xxFQDu9evIwrBc1oPvkS97gMxusKji4QxM95MPmZ6JQ=\n-----END CERTIFICATE-----";
        CertificateFactory factory = CertificateFactory.getInstance("X.509");
        ByteArrayInputStream certStream = new ByteArrayInputStream(cert.getBytes());
        X509Certificate certificate = (X509Certificate) factory.generateCertificate(certStream);

        return Saml2X509Credential.signing(privateKey, certificate);
    }
}
