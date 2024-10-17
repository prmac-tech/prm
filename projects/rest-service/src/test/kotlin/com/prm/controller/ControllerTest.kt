package com.prm.controller

import org.assertj.core.api.Assertions.assertThat
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test

class ControllerTest {

    private lateinit var controller: Controller

    @BeforeEach
    fun setUp() {
        controller = Controller()
    }

    @Test
    fun `it returns message`() {
        assertThat(controller.hello()).isEqualTo("Hello K8s")
    }
}