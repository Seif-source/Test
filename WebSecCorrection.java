package com.example.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.saml2.provider.service.web.authentication.logout.Saml2LogoutRequestFilter;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
public class WebSecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/saml/**", "/css/**", "/js/**").permitAll()
                .anyRequest().authenticated()
            )
            .saml2Login(saml2 -> saml2
                .relyingPartyRegistrationRepository(relyingPartyRegistrationRepository())
            )
            .saml2Logout(saml2Logout -> saml2Logout
                .logoutRequestMatcher(new Saml2LogoutRequestFilter())
            )
            .csrf().disable();

        return http.build();
    }

    @Bean
    public RelyingPartyRegistrationRepository relyingPartyRegistrationRepository() {
        return new InMemoryRelyingPartyRegistrationRepository(RelyingPartyRegistrationConfig.buildRelyingPartyRegistration());
    }
}

