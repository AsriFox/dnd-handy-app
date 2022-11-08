package com.example.dndhandy.api

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material.MaterialTheme
import androidx.compose.material.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp

@Composable
fun ApiNullScreen(requestPath: String) {
    Column(
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally,
        modifier = Modifier
            .fillMaxSize()
            .padding(20.dp)
    ) {
        Text(
            text = "Nothing found at\n'$requestPath'",
            textAlign = TextAlign.Center,
            fontSize = MaterialTheme.typography.h4.fontSize,
        )
    }
}

@Preview
@Composable
fun ApiNullScreenPreview() {
    ApiNullScreen(requestPath = "api/classes/barbarian/features")
}
