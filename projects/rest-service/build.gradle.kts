import com.prm.extensions.ClassPathExtension

apply(plugin = "com.google.cloud.tools.jib")

dependencies {
    implementation("org.springframework.boot:spring-boot-starter-actuator")
    implementation("org.springframework.boot:spring-boot-starter-data-jpa")
    implementation("org.springframework.boot:spring-boot-starter-security")
    implementation("org.springframework.boot:spring-boot-starter-validation")
    implementation("org.springframework.boot:spring-boot-starter-web")
    implementation("org.jetbrains.kotlin:kotlin-reflect")
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8")
    implementation("com.fasterxml.jackson.module:jackson-module-kotlin")
    implementation("com.h2database:h2")
    testImplementation("org.springframework.boot:spring-boot-starter-test")
}

configure<ClassPathExtension> {
    jacocoExclusions = listOf(
        "**/config/**",
        "**/entity/**",
        "**/ApplicationKt.class"
    )
}
