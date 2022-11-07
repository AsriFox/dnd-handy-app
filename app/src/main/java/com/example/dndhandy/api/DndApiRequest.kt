package com.example.dndhandy.api

import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.runBlocking
import kotlinx.coroutines.withContext

fun sendGetRequest(requestPath: String) = runBlocking {
    withContext(Dispatchers.Default) {
        try {
            java.net.URL("https://dnd5eapi.co/$requestPath").readText()
        } catch (e: java.lang.Exception) {
            android.util.Log.d("Request Failed", e.message ?: e.toString())
            null
        }
    }
}?.let {
    try {
        org.json.JSONObject(it)
    }
    catch (e: org.json.JSONException) {
        null
    }
}