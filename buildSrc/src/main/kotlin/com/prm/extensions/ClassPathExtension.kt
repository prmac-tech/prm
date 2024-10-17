package com.prm.extensions
abstract class ClassPathExtension(
    var jacocoExclusions: List<String>,
    var sonarExclusions: List<String>
)