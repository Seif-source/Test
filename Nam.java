package com.ca.cib.acint.ihm.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.saml2.provider.service.registration.InMemoryRelyingPartyRegistrationRepository;
import org.springframework.security.saml2.provider.service.registration.RelyingPartyRegistration;
import org.springframework.security.saml2.provider.service.registration.RelyingPartyRegistrationRepository;
import org.springframework.security.web.SecurityFilterChain;

import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;
import java.io.ByteArrayInputStream;
import java.nio.charset.StandardCharsets;

@Configuration
public class WebSecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http, RelyingPartyRegistrationRepository relyingPartyRegistrationRepository) throws Exception {
        http
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/saml/**", "/css/**", "/js/**", "/fonts/**", "/webjars/**", "/error/**", "/logout").permitAll()
                .anyRequest().authenticated()
            )
            .saml2Login(saml2 -> saml2
                .relyingPartyRegistrationRepository(relyingPartyRegistrationRepository)
            )
            .saml2Logout(saml2Logout -> saml2Logout
                .logoutRequestMatcher("/saml/logout")
            )
            .csrf().disable(); // Disable CSRF for simplicity. Adapt to your security requirements.

        return http.build();
    }

    @Bean
    public RelyingPartyRegistrationRepository relyingPartyRegistrationRepository() throws Exception {
        RelyingPartyRegistration relyingPartyRegistration = RelyingPartyRegistration
            .withRegistrationId("acint-idp")
            .entityId("http://localhost:8080/acint/saml/sp") // SP Entity ID
            .assertionConsumerServiceLocation("http://localhost:8080/acint/saml/SSO/alias/acint.local") // ACS location
            .assertingPartyDetails(details -> details
                .entityId("https://intra.usignon.int.cm.par.emea.cib/2025_ECH_Acint") // IdP Entity ID
                .singleSignOnServiceLocation("https://intra.usignon.int.cm.par.emea.cib/SSOService")
                .verificationX509Credentials(c -> c.add(verificationCredential()))
            )
            .build();

        return new InMemoryRelyingPartyRegistrationRepository(relyingPartyRegistration);
    }

    private X509Certificate verificationCredential() throws Exception {
        String certificate = """
            -----BEGIN CERTIFICATE-----
            YOUR_CERTIFICATE_CONTENT_HERE
            -----END CERTIFICATE-----
            """;

        CertificateFactory factory = CertificateFactory.getInstance("X.509");
        return (X509Certificate) factory.generateCertificate(
            new ByteArrayInputStream(certificate.getBytes(StandardCharsets.UTF_8))
        );
    }

    private X509Certificate signingCredential() throws Exception {
        String signingCertificate = """
            -----BEGIN CERTIFICATE-----
            YOUR_SIGNING_CERTIFICATE_CONTENT_HERE
            -----END CERTIFICATE-----
            """;

        CertificateFactory factory = CertificateFactory.getInstance("X.509");
        return (X509Certificate) factory.generateCertificate(
            new ByteArrayInputStream(signingCertificate.getBytes(StandardCharsets.UTF_8))
        );
    }

    @Bean
    public SAMLUserDetailsServiceImpl samlUserDetailsService() {
        return new SAMLUserDetailsServiceImpl(); // Your custom UserDetailsService implementation
    }

    @Bean
    public AuthenticationManager authenticationManager(HttpSecurity http) throws Exception {
        return http.getSharedObject(AuthenticationManagerBuilder.class).build();
    }

    @Bean
    public MetadataDisplayFilter metadataDisplayFilter() {
        return new MetadataDisplayFilter();
    }

    @Bean
    public SAMLProcessingFilter samlWebSSOProcessingFilter(AuthenticationManager authenticationManager) throws Exception {
        SAMLProcessingFilter filter = new SAMLProcessingFilter();
        filter.setAuthenticationManager(authenticationManager);
        filter.setAuthenticationSuccessHandler(successRedirectHandler());
        filter.setAuthenticationFailureHandler(failureHandler());
        return filter;
    }

    @Bean
    public SAMLLogoutFilter samlLogoutFilter() {
        return new SAMLLogoutFilter(successLogoutHandler(), logoutHandler(), new LogoutSuccessHandlerImpl());
    }

    @Bean
    public SimpleUrlLogoutSuccessHandler successLogoutHandler() {
        SimpleUrlLogoutSuccessHandler handler = new SimpleUrlLogoutSuccessHandler();
        handler.setDefaultTargetUrl("/logout");
        return handler;
    }

    @Bean
    public LogoutHandler logoutHandler() {
        return new SecurityContextLogoutHandler();
    }

    @Bean
    public SimpleUrlAuthenticationSuccessHandler successRedirectHandler() {
        SimpleUrlAuthenticationSuccessHandler handler = new SimpleUrlAuthenticationSuccessHandler();
        handler.setDefaultTargetUrl("/home");
        return handler;
    }

    @Bean
    public SimpleUrlAuthenticationFailureHandler failureHandler() {
        return new SimpleUrlAuthenticationFailureHandler();
    }
}
