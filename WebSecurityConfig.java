package com.ca.cib.acint.ihm.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.saml2.provider.service.registration.RelyingPartyRegistrationRepository;
import org.springframework.security.web.SecurityFilterChain;

import static org.springframework.security.config.Customizer.withDefaults;

@Configuration
@EnableWebSecurity
public class WebSecurityConfig {
    private static final String LOGOUT_URL = "/logout";
    private static final String SAML_URL = "/saml/**";

    @Value("${env}")
    private String env;

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http,
                                                   RelyingPartyRegistrationRepository relyingPartyRegistrationRepository) throws Exception {
        http
                .authorizeHttpRequests(authorize -> authorize
                        .requestMatchers("/css/**", "/images/**", "/js/**", "/fonts/**", "/webjars/**", LOGOUT_URL).permitAll() // Autoriser les chemins spécifiques
                        .requestMatchers(SAML_URL).permitAll()
                        .anyRequest().authenticated() // Authentification requise pour toutes les autres requêtes
                )
                .saml2Login(saml2 -> saml2
                        .relyingPartyRegistrationRepository(relyingPartyRegistrationRepository) // Configuration SAML par défaut
                )
                .saml2Logout(withDefaults()) // Configuration de déconnexion SAML
                .csrf(AbstractHttpConfigurer::disable) // Désactiver CSRF (optionnel)
                .logout(logout -> logout
                        .logoutUrl(LOGOUT_URL)
                        .invalidateHttpSession(true)
                );

        return http.build();
    }
}
