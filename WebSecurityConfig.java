package com.ca.cib.acint.ihm.config;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.apache.velocity.app.VelocityEngine;
import org.opensaml.saml2.metadata.provider.FilesystemMetadataProvider;
import org.opensaml.saml2.metadata.provider.MetadataProvider;
import org.opensaml.saml2.metadata.provider.MetadataProviderException;
import org.opensaml.xml.parse.StaticBasicParserPool;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import org.springframework.core.io.ClassPathResource;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.saml.SAMLAuthenticationProvider;
import org.springframework.security.saml.SAMLBootstrap;
import org.springframework.security.saml.SAMLDiscovery;
import org.springframework.security.saml.SAMLEntryPoint;
import org.springframework.security.saml.SAMLLogoutFilter;
import org.springframework.security.saml.SAMLLogoutProcessingFilter;
import org.springframework.security.saml.SAMLProcessingFilter;
import org.springframework.security.saml.SAMLWebSSOHoKProcessingFilter;
import org.springframework.security.saml.context.SAMLContextProviderImpl;
import org.springframework.security.saml.key.EmptyKeyManager;
import org.springframework.security.saml.key.KeyManager;
import org.springframework.security.saml.log.SAMLDefaultLogger;
import org.springframework.security.saml.metadata.CachingMetadataManager;
import org.springframework.security.saml.metadata.ExtendedMetadata;
import org.springframework.security.saml.metadata.ExtendedMetadataDelegate;
import org.springframework.security.saml.metadata.MetadataDisplayFilter;
import org.springframework.security.saml.parser.ParserPoolHolder;
import org.springframework.security.saml.processor.HTTPPostBinding;
import org.springframework.security.saml.processor.HTTPRedirectDeflateBinding;
import org.springframework.security.saml.processor.SAMLBinding;
import org.springframework.security.saml.processor.SAMLProcessorImpl;
import org.springframework.security.saml.util.VelocityFactory;
import org.springframework.security.saml.websso.SingleLogoutProfile;
import org.springframework.security.saml.websso.SingleLogoutProfileImpl;
import org.springframework.security.saml.websso.WebSSOProfile;
import org.springframework.security.saml.websso.WebSSOProfileConsumer;
import org.springframework.security.saml.websso.WebSSOProfileConsumerHoKImpl;
import org.springframework.security.saml.websso.WebSSOProfileConsumerImpl;
import org.springframework.security.saml.websso.WebSSOProfileECPImpl;
import org.springframework.security.saml.websso.WebSSOProfileImpl;
import org.springframework.security.saml.websso.WebSSOProfileOptions;
import org.springframework.security.web.DefaultSecurityFilterChain;
import org.springframework.security.web.FilterChainProxy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.SavedRequestAwareAuthenticationSuccessHandler;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationFailureHandler;
import org.springframework.security.web.authentication.logout.LogoutHandler;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.security.web.authentication.logout.SimpleUrlLogoutSuccessHandler;
import org.springframework.security.web.authentication.preauth.x509.X509AuthenticationFilter;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

/**
 * Configuration of Spring Security
 * 
 * @author ut27ad
 *
 */
@Configuration
@EnableWebSecurity
@EnableGlobalMethodSecurity(prePostEnabled = true)
@Profile("!test")
public class WebSecurityConfig extends WebSecurityConfigurerAdapter {
	private static final String APPLICATION_NAME = "acint";
	private static final int MAX_AUTHENTICATION_AGE = 60 * 60 * 10;
	private static final String LOGOUT_URL = "/logout";
	private static final String IDP_METADATA_XML = "idp_metadata.xml";
	private static final String SP_METADATA_XML = "sp_metadata.xml";
	private static final String SAML_URL = "/saml/**";

	@Value("${env}")
	private String env;
	
	/**
	 * Configure the bypass request
	 * No check for these requests
	 */
	@Override
	public void configure(WebSecurity web) throws Exception {
		web.ignoring().antMatchers("/css/**", "/images/**", "/js/**", "/fonts/**", "/webjars/**", "/error/**", LOGOUT_URL);
	}

	/**
	 * Options of http security like: custom filters, authorization for requests, session management, logout handler, ...
	 */
	@Override
	protected void configure(HttpSecurity http) throws Exception {
		http
		.authorizeRequests()
			.antMatchers(SAML_URL).permitAll()
			.anyRequest().authenticated()
		.and()
			.httpBasic()
			.authenticationEntryPoint(samlEntryPoint())
		.and()
			.sessionManagement()
				.sessionCreationPolicy(SessionCreationPolicy.ALWAYS)
				.enableSessionUrlRewriting(false)
				// redirect to choose page when session timeout
				.invalidSessionUrl("/") 
				.sessionFixation().migrateSession()
		.and()
			.csrf().ignoringAntMatchers(SAML_URL)
		.and()
			// authentication SSO
			.addFilterAt(samlFilter(), X509AuthenticationFilter.class) 
			.logout()
				.invalidateHttpSession(true)
				.clearAuthentication(false)
				.logoutRequestMatcher(new AntPathRequestMatcher(LOGOUT_URL))
				.logoutSuccessUrl(LOGOUT_URL)
		;
	}
	
	@Override
	protected void configure(AuthenticationManagerBuilder auth) throws Exception {
		auth.authenticationProvider(samlAuthenticationProvider());
	}
	
	@Bean
	public WebSSOProfileOptions defaultWebSSOProfileOptions() {
		WebSSOProfileOptions webSSOProfileOptions = new WebSSOProfileOptions();
		webSSOProfileOptions.setIncludeScoping(false);
		// Change from false to true to prevent the problem of expiration of token (7200s) 
		// org.springframework.security.authentication.CredentialsExpiredException
		webSSOProfileOptions.setForceAuthN(true);
		// Add to use post method than redirect, for the problem of clicking a link in winword document
		webSSOProfileOptions.setBinding("urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST");
		return webSSOProfileOptions;
	}

	// Entry point to initialize authentication, default values taken from
	// properties file
	@Bean
	public SAMLEntryPoint samlEntryPoint() {
		SAMLEntryPoint samlEntryPoint = new SAMLEntryPoint();
		samlEntryPoint.setDefaultProfileOptions(defaultWebSSOProfileOptions());
		return samlEntryPoint;
	}
	
	// SAML Authentication Provider responsible for validating of received SAML
	// messages
	@Bean
	public SAMLAuthenticationProvider samlAuthenticationProvider() {
		SAMLAuthenticationProvider samlAuthenticationProvider = new SAMLAuthenticationProvider();
		samlAuthenticationProvider.setUserDetails(new SAMLUserDetailsServiceImpl());
		samlAuthenticationProvider.setForcePrincipalAsString(false);
		return samlAuthenticationProvider;
	}

	// Handler for successful logout
	@Bean
	public SimpleUrlLogoutSuccessHandler successLogoutHandler() {
		SimpleUrlLogoutSuccessHandler successLogoutHandler = new SimpleUrlLogoutSuccessHandler();
		successLogoutHandler.setDefaultTargetUrl(LOGOUT_URL);
		return successLogoutHandler;
	}

	// Logout handler terminating local session
	@Bean
	public SecurityContextLogoutHandler logoutHandler() {
		SecurityContextLogoutHandler logoutHandler = new SecurityContextLogoutHandler();
		logoutHandler.setInvalidateHttpSession(true);
		logoutHandler.setClearAuthentication(false);
		return logoutHandler;
	}

	// Overrides default logout processing filter with the one processing SAML
	// messages
	@Bean
	public SAMLLogoutFilter samlLogoutFilter() {
		return new SAMLLogoutFilter(successLogoutHandler(),
				new LogoutHandler[] { logoutHandler() },
				new LogoutHandler[] { logoutHandler() });
	}

	// The filter is waiting for connections on URL suffixed with filterSuffix
	// and presents SP metadata there
	@Bean
	public MetadataDisplayFilter metadataDisplayFilter() {
		return new MetadataDisplayFilter();
	}

	// Processing filter for WebSSO profile messages
	@Bean
	public SAMLProcessingFilter samlWebSSOProcessingFilter() throws Exception {
		SAMLProcessingFilter samlWebSSOProcessingFilter = new SAMLProcessingFilter();
		samlWebSSOProcessingFilter.setAuthenticationManager(authenticationManager());
		samlWebSSOProcessingFilter.setAuthenticationSuccessHandler(successRedirectHandler());
		samlWebSSOProcessingFilter.setAuthenticationFailureHandler(authenticationFailureHandler());
		return samlWebSSOProcessingFilter;
	}

	// Handler deciding where to redirect user after successful login
	@Bean
	public SavedRequestAwareAuthenticationSuccessHandler successRedirectHandler() {
		SavedRequestAwareAuthenticationSuccessHandler successRedirectHandler =
				new SavedRequestAwareAuthenticationSuccessHandler();
		successRedirectHandler.setDefaultTargetUrl("/");
		return successRedirectHandler;
	}

	// Handler deciding where to redirect user after failed login
	@Bean
	public SimpleUrlAuthenticationFailureHandler authenticationFailureHandler() {
		SimpleUrlAuthenticationFailureHandler failureHandler =
				new SimpleUrlAuthenticationFailureHandler();
		failureHandler.setUseForward(true);
		failureHandler.setDefaultFailureUrl("/error/403");
		return failureHandler;
	}

	@Bean
	public SAMLWebSSOHoKProcessingFilter samlWebSSOHoKProcessingFilter() throws Exception {
		SAMLWebSSOHoKProcessingFilter samlWebSSOHoKProcessingFilter = new SAMLWebSSOHoKProcessingFilter();
		samlWebSSOHoKProcessingFilter.setAuthenticationManager(authenticationManager());
		samlWebSSOHoKProcessingFilter.setAuthenticationSuccessHandler(successRedirectHandler());
		samlWebSSOHoKProcessingFilter.setAuthenticationFailureHandler(authenticationFailureHandler());
		return samlWebSSOHoKProcessingFilter;
	}

	// Filter processing incoming logout messages
	// First argument determines URL user will be redirected to after successful
	// global logout
	@Bean
	public SAMLLogoutProcessingFilter samlLogoutProcessingFilter() {
		return new SAMLLogoutProcessingFilter(successLogoutHandler(), logoutHandler());
	}

	// IDP Discovery Service
	@Bean
	public SAMLDiscovery samlIDPDiscovery() {
		SAMLDiscovery idpDiscovery = new SAMLDiscovery();
		idpDiscovery.setIdpSelectionPath("/saml/idpSelection");
		return idpDiscovery;
	}

	/**
	 * Define the security filter chain in order to support SSO Auth by using SAML 2.0
	 * 
	 * @return Filter chain proxy
	 * @throws Exception
	 */
	@Bean
	public FilterChainProxy samlFilter() throws Exception {
		List<SecurityFilterChain> chains = new ArrayList<>();
		chains.add(new DefaultSecurityFilterChain(new AntPathRequestMatcher("/saml/login/**"),
				samlEntryPoint()));
		chains.add(new DefaultSecurityFilterChain(new AntPathRequestMatcher("/saml/logout/**"),
				samlLogoutFilter()));
		chains.add(new DefaultSecurityFilterChain(new AntPathRequestMatcher("/saml/metadata/**"),
				metadataDisplayFilter()));
		chains.add(new DefaultSecurityFilterChain(new AntPathRequestMatcher("/saml/SSO/**"),
				samlWebSSOProcessingFilter()));
		chains.add(new DefaultSecurityFilterChain(new AntPathRequestMatcher("/saml/SSOHoK/**"),
				samlWebSSOHoKProcessingFilter()));
		chains.add(new DefaultSecurityFilterChain(new AntPathRequestMatcher("/saml/SingleLogout/**"),
				samlLogoutProcessingFilter()));
		chains.add(new DefaultSecurityFilterChain(new AntPathRequestMatcher("/saml/discovery/**"),
				samlIDPDiscovery()));
		return new FilterChainProxy(chains);
	}

	// Logger for SAML messages and events
	@Bean
	public SAMLDefaultLogger samlLogger() {
		return new SAMLDefaultLogger();
	}

	// Central storage of cryptographic keys
	@Bean
	public KeyManager keyManager() {
		return new EmptyKeyManager();
	}

	// XML parser pool needed for OpenSAML parsing
	@Bean(initMethod = "initialize")
	public StaticBasicParserPool parserPool() {
		return new StaticBasicParserPool();
	}

	@Bean(name = "parserPoolHolder")
	public ParserPoolHolder parserPoolHolder() {
		return new ParserPoolHolder();
	}

	@Bean
	public ExtendedMetadataDelegate idpExtendedMetadataProvider() throws MetadataProviderException, IOException {
		File idpMetadata = new ClassPathResource(IDP_METADATA_XML).getFile();
		FilesystemMetadataProvider filesystemMetadataProvider = new FilesystemMetadataProvider(idpMetadata);
		filesystemMetadataProvider.setParserPool(parserPool());
		return new ExtendedMetadataDelegate(filesystemMetadataProvider, new ExtendedMetadata());
	}

	// Setup advanced info about metadata
	@Bean
	public ExtendedMetadata spExtendedMetadata() {
		ExtendedMetadata extendedMetadata = new ExtendedMetadata();
		extendedMetadata.setLocal(true);
		extendedMetadata.setAlias(APPLICATION_NAME + "." + env.toLowerCase());
		extendedMetadata.setSecurityProfile("metaiop");
		extendedMetadata.setSslSecurityProfile("pkix");
		extendedMetadata.setSigningKey("whiteapp-signing");
		extendedMetadata.setRequireLogoutRequestSigned(false);
		extendedMetadata.setRequireLogoutResponseSigned(false);
		extendedMetadata.setIdpDiscoveryEnabled(false);

		return extendedMetadata;
	}

	@Bean
	public ExtendedMetadataDelegate spExtendedMetadataProvider() throws MetadataProviderException, IOException {
		File spMetadata = new ClassPathResource(SP_METADATA_XML).getFile();
		FilesystemMetadataProvider filesystemMetadataProvider = new FilesystemMetadataProvider(spMetadata);
		filesystemMetadataProvider.setParserPool(parserPool());
		return new ExtendedMetadataDelegate(filesystemMetadataProvider, spExtendedMetadata());
	}

	// IDP Metadata configuration - paths to metadata of IDPs in circle of trust
	// is here
	// Do no forget to call iniitalize method on providers
	@Bean
	@Qualifier("metadata")
	public CachingMetadataManager metadata() throws MetadataProviderException, IOException {
		List<MetadataProvider> providers = new ArrayList<>();
		providers.add(idpExtendedMetadataProvider());
		providers.add(spExtendedMetadataProvider());
		return new CachingMetadataManager(providers);
	}

	// Provider of default SAML Context
	@Bean
	public SAMLContextProviderImpl contextProvider() {
		return new SAMLContextProviderImpl();
	}

	// Initialization of the velocity engine
	@Bean
	public VelocityEngine velocityEngine() {
		return VelocityFactory.getEngine();
	}

	@Bean
	public HTTPPostBinding httpPostBinding() {
		return new HTTPPostBinding(parserPool(), velocityEngine());
	}

	@Bean
	public HTTPRedirectDeflateBinding httpRedirectDeflateBinding() {
		return new HTTPRedirectDeflateBinding(parserPool());
	}

	// Class loading incoming SAML messages from httpRequest stream
	@Bean(name = "processor")
	public SAMLProcessorImpl samlProcessorImpl() {
		List<SAMLBinding> samlBindings = new ArrayList<>();
		samlBindings.add(httpRedirectDeflateBinding());
		samlBindings.add(httpPostBinding());

		return new SAMLProcessorImpl(samlBindings);
	}

	// Initialization of OpenSAML library
	@Bean
	public static SAMLBootstrap sAMLBootstrap() {
		return new SAMLBootstrap();
	}

	// SAML 2.0 WebSSO Assertion Consumer
	@Bean
	public WebSSOProfileConsumer webSSOprofileConsumer() {
		WebSSOProfileConsumerImpl webSSOProfileConsumerImpl = new WebSSOProfileConsumerImpl();
		// Change from false to true to prevent the problem of expiration of token (7200s) 
				// org.springframework.security.authentication.CredentialsExpiredException
		webSSOProfileConsumerImpl.setMaxAuthenticationAge(MAX_AUTHENTICATION_AGE);
		return webSSOProfileConsumerImpl;
	}

	// SAML 2.0 Holder-of-Key WebSSO Assertion Consumer
	@Bean
	public WebSSOProfileConsumerHoKImpl hokWebSSOprofileConsumer() {
		return new WebSSOProfileConsumerHoKImpl();
	}

	// SAML 2.0 Web SSO profile
	@Bean
	public WebSSOProfile webSSOprofile() {
		return new WebSSOProfileImpl();
	}

	// SAML 2.0 Holder-of-Key Web SSO profile
	@Bean
	public WebSSOProfileConsumerHoKImpl hokWebSSOProfile() {
		return new WebSSOProfileConsumerHoKImpl();
	}

	// SAML 2.0 ECP profile
	@Bean
	public WebSSOProfileECPImpl ecpprofile() {
		return new WebSSOProfileECPImpl();
	}

	@Bean
	public SingleLogoutProfile logoutprofile() {
		return new SingleLogoutProfileImpl();
	}
	
	@Bean
	public SAMLDefaultLogger samlDefaultLogger() {
	    SAMLDefaultLogger samlDefaultLogger = new SAMLDefaultLogger();
	    samlDefaultLogger.setLogAllMessages(true);
	    return samlDefaultLogger;
	}
}
