package com.example.dndhandy.api.list

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material.MaterialTheme
import androidx.compose.material.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import org.json.JSONObject

class ApiListEntry(
    val index: String,
    private val name: String,
    private val url: String,
    private val navController: NavController,
) {

    constructor(
        content: JSONObject,
        navController: NavController,
    ) : this(
        index = content.getString("index"),
        name = content.getString("name"),
        url = content.getString("url").drop(1),
        navController = navController,
    )

    @Composable
    fun Construct() = ApiListEntry(name) {
        navController.navigate(
            url.replace('/', '.')
        )
    }
}

@Composable
private fun ApiListEntry(
    name: String,
    onClick: () -> Unit,
) {
    Text(
        text = name,
        fontSize = MaterialTheme.typography.subtitle1.fontSize,
        modifier = Modifier
            .fillMaxWidth()
            .padding(10.dp)
            .clickable(
                enabled = true,
                onClick = onClick,
            )
    )
}

@Preview
@Composable
fun ApiListEntryPreview() {
    ApiListEntry(
        name = "example",
        onClick = {}
    )
}