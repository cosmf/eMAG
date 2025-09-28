package com.example.emag.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

public record CreateClientRequest(
        @NotBlank String cnp,
        @NotBlank String firstName,
        @NotBlank String lastName,
        @Email String email
) {}
