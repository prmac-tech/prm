package com.prm.controller

import org.assertj.core.api.Assertions.assertThat
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.test.web.servlet.MockMvc
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders
import org.springframework.test.web.servlet.result.MockMvcResultMatchers

@AutoConfigureMockMvc
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
class ControllerTest {

    @Autowired
    lateinit var mockMvc: MockMvc

    @Test
    fun `it returns message for GET prm `() {
        val response = mockMvc
            .perform(
                MockMvcRequestBuilders.get("/prm/hello")
            )
            .andExpect(MockMvcResultMatchers.status().isOk)
            .andReturn().response
        assertThat(response.contentAsString).isEqualTo("Hello K8s")
    }
}