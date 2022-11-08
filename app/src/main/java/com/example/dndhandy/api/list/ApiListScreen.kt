package com.example.dndhandy.api.list

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import com.example.dndhandy.DefaultAppBar
import com.example.dndhandy.SearchAppBar
import com.example.dndhandy.search.SearchWidgetState
import org.json.JSONArray
import org.json.JSONException
import org.json.JSONObject

@Composable
fun ApiListScreen(
    navController: NavController,
    apiEntriesArray: JSONArray,
) = Array(
    size = apiEntriesArray.length(),
) {
    try {
        apiEntriesArray.getJSONObject(it)
    } catch (e: JSONException) {
        null
    }
}.let {
    ApiListScreen(
        navController,
        apiEntriesArray = it,
    )
}

@Composable
fun ApiListScreen(
    navController: NavController,
    apiEntriesArray: Array<JSONObject?>
) = ApiListScreen(
    apiEntries = apiEntriesArray
        .filterNotNull()
        .mapNotNull {
            try {
                ApiListEntry(
                    content = it,
                    navController,
                )
            } catch (e: JSONException) {
                null
            }
        }
)

@Composable
fun ApiListScreen(
    apiEntries: Collection<ApiListEntry>,
) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .verticalScroll(
                state = rememberScrollState(),
            )
    ) {
        apiEntries.forEach {
            it.Construct()
        }
    }
}