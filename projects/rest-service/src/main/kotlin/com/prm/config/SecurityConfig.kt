package com.prm.config

import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean
import org.springframework.boot.autoconfigure.security.ConditionalOnDefaultWebSecurity
import org.springframework.boot.context.properties.ConfigurationProperties
import org.springframework.boot.context.properties.EnableConfigurationProperties
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity
import org.springframework.security.config.annotation.web.builders.HttpSecurity
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity
import org.springframework.security.web.SecurityFilterChain
import java.util.Collections.emptyList

fun interface SecurityConfigurer {
    fun configure(http: HttpSecurity): HttpSecurity
}

@Configuration
@EnableWebSecurity
@EnableMethodSecurity
@ConditionalOnDefaultWebSecurity
@EnableConfigurationProperties(SecurityConfig.OAuth2Properties::class)
class SecurityConfig(private val configurers: List<SecurityConfigurer>) {

    @Bean
    @ConditionalOnMissingBean
    fun configure(http: HttpSecurity): SecurityFilterChain {
        configurers.forEach { it.configure(http) }
        return http.build()
    }


    @ConfigurationProperties(prefix = "oauth2")
    class OAuth2Properties {
        var roles: List<String> = emptyList()
    }
}