package com.example.dndhandy.api

import androidx.compose.runtime.Composable
import androidx.navigation.NavController
import com.example.dndhandy.MainViewModel
import com.example.dndhandy.api.article.ApiArticleScreen
import com.example.dndhandy.api.list.ApiListScreen

@Composable
fun ApiScreen(
    requestPath: String,
    navController: NavController,
    mainViewModel: MainViewModel,
) {
    val response = sendGetRequest(requestPath)
        ?: run {
            // Response is null
            ApiNullScreen(requestPath)
            return@ApiScreen
        }

    response.toJsonObject()?.let {
        // Response is JSONObject
        if (it.has("count")) {
            // List of references
            it.optJSONArray("results")?.let { array ->
                ApiListScreen(
                    navController,
                    apiEntriesArray = array
                )
            }
        } else if (it.has("name")) {
            mainViewModel.updateTitleState(
                newValue = it.getString("name")
            )

            if (it.has("desc")) {
                val category = it.optString("url")
//                    .trimEnd()
//                    .trimEnd('/')
                    .substringBeforeLast('/')
                    .substringAfterLast('/')
                    .replace('-', ' ')

                val desc = it.optJSONArray("desc")
                if (desc == null) {
                    ApiArticleScreen(
                        category,
                        desc = it.optString("desc"),
                    )
                } else {
                    ApiArticleScreen(category, desc)
                }
            } else if (it.has("equipment")) {

            } else if (it.has("subclasses")) {

            } else null
        } else if (it.has("level")) {
            // Level information

        } else null
    }
    ?:
    response.toJsonArray()?.let {
        // Response is JSONArray

    }
    ?:
    run {
        // Response is not JSONObject nor JSONArray
        android.util.Log.d("Response is invalid", response)
        ApiNullScreen(requestPath)
    }
}