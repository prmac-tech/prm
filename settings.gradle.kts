rootProject.name = "prm-services"
include(
    // ⌄ add new projects here
    "rest-service",
)

// load children from the "projects" directory (and drop the prefix)
fun ProjectDescriptor.allChildren(): Set<ProjectDescriptor> = children + children.flatMap { it.allChildren() }
rootProject.allChildren()
    .filter { !it.path.startsWith(":libs") }
    .forEach { it.projectDir = File(rootDir, "projects/${it.projectDir.relativeTo(rootDir)}") }

dependencyResolutionManagement {
    versionCatalogs {
        create("libs") {
            library("aws-autoconfigure", "io.awspring.cloud:spring-cloud-aws-autoconfigure:3.2.0")
            library("aws-starter", "io.awspring.cloud:spring-cloud-aws-starter:3.2.0")
            library("aws-sns", "io.awspring.cloud:spring-cloud-aws-starter-sns:3.2.0")
            library("aws-sqs", "io.awspring.cloud:spring-cloud-aws-starter-sqs:3.2.0")
            library("aws-sts", "software.amazon.awssdk:sts:2.28.6")
            library("aws-query-protocol", "software.amazon.awssdk:aws-query-protocol:2.28.6")
            bundle(
                "aws-messaging",
                listOf("aws-autoconfigure", "aws-starter", "aws-sns", "aws-sqs", "aws-sts", "aws-query-protocol")
            )
            library("mockito-kotlin", "org.mockito.kotlin:mockito-kotlin:5.4.0")
            library("mockito-inline", "org.mockito:mockito-inline:5.2.0")
            bundle("mockito", listOf("mockito-kotlin", "mockito-inline"))
            library("insights", "com.microsoft.azure:applicationinsights-web:3.5.4")
            library("sentry", "io.sentry:sentry-spring-boot-starter-jakarta:7.14.0")
            library(
                "opentelemetry-annotations",
                "io.opentelemetry.instrumentation:opentelemetry-instrumentation-annotations:2.8.0"
            )
            bundle("telemetry", listOf("insights", "opentelemetry-annotations", "sentry"))
            library("springdoc", "org.springdoc:springdoc-openapi-starter-webmvc-ui:2.6.0")
            library("asyncapi", "org.openfolder:kotlin-asyncapi-spring-web:3.0.3")
            library("wiremock", "org.wiremock:wiremock-standalone:3.9.1")
        }
    }
}

plugins { id("com.gradle.develocity") version "3.18.1" }
develocity {
    buildScan {
        publishing.onlyIf { !System.getenv("CI").isNullOrEmpty() }
        termsOfUseUrl.set("https://gradle.com/help/legal-terms-of-use")
        termsOfUseAgree.set("yes")
    }
}
