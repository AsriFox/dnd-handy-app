package com.example.dndhandy.api

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.navigation.NavController
import com.example.dndhandy.api.list.ApiListScreen
import org.json.JSONException
import org.json.JSONObject

@Composable
fun ApiScreen(
    navController: NavController,
    requestPath: String,
) = sendGetRequest(requestPath)?.let {
    if (it.has("count") and it.has("results")) {
        return ApiListScreen(
            navController,
            apiEntriesArray = it.getJSONArray("results")
        )
    } else if (it.has("index") and it.has("name") and it.has("url")) {
        return ApiNullScreen(requestPath)
    }
} ?: ApiNullScreen(requestPath)

@Composable
fun ApiNullScreen(requestPath: String) {
    Column(
        modifier = Modifier.fillMaxSize(),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally,
    ) {
        Text(text = "Nothing found at\n'$requestPath'")
    }
}
