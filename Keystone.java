private Saml2X509Credential signingCredential() throws Exception {
    String keystorePath = "C:\\path\\to\\keystore.jks";
    String keystorePassword = "your-keystore-password";
    String keyAlias = "your-key-alias";

    KeyStore keyStore = KeyStore.getInstance("JKS");
    try (FileInputStream fis = new FileInputStream(keystorePath)) {
        keyStore.load(fis, keystorePassword.toCharArray());
    }

    // Retrieve the private key
    Key key = keyStore.getKey(keyAlias, keystorePassword.toCharArray());
    if (!(key instanceof PrivateKey)) {
        throw new IllegalStateException("The key is not a private key");
    }
    PrivateKey privateKey = (PrivateKey) key;

    // Retrieve the certificate
    Certificate certificate = keyStore.getCertificate(keyAlias);
    if (certificate == null) {
        throw new IllegalStateException("Certificate not found for alias: " + keyAlias);
    }

    X509Certificate x509Certificate = (X509Certificate) certificate;

    // Create and return the signing credential
    return Saml2X509Credential.signing(privateKey, x509Certificate);
}
