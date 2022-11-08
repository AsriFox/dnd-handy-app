package com.example.dndhandy.api

import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.runBlocking
import kotlinx.coroutines.withContext
import org.json.JSONArray
import org.json.JSONException
import org.json.JSONObject

fun sendGetRequest(requestPath: String) = runBlocking {
    withContext(Dispatchers.Default) {
        try {
            java.net.URL("https://dnd5eapi.co/$requestPath").readText()
        } catch (e: java.lang.Exception) {
            android.util.Log.d("Request Failed", e.message ?: e.toString())
            null
        }
    }
}

internal fun String.toJsonObject() =
    try { JSONObject(this) }
    catch (e: JSONException) { null }

internal fun String.toJsonArray() =
    try { JSONArray(this) }
    catch (e: JSONException) { null }
