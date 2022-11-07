package com.example.dndhandy.api.list

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.material.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.navigation.NavController
import androidx.navigation.NavOptions
import androidx.navigation.Navigator
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
    fun Construct() {
        Text(
            text = name,
            modifier = Modifier
                .fillMaxWidth()
                .clickable(
                    enabled = true,
                    onClick = {
                        navController.navigate(
                            url.replace('/', '.')
                        )
                    }
                )
        )
    }
}