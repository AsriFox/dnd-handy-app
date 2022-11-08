package com.example.dndhandy

import androidx.compose.runtime.Composable
import com.example.dndhandy.search.SearchWidgetState

@Composable
fun MainAppBar(
    titleState: String,
    searchWidgetState: SearchWidgetState,
    searchTextState: String,
    onTextChange: (String) -> Unit,
    onCloseClicked: () -> Unit,
    onSearchClicked: (String) -> Unit,
    onSearchTriggered: () -> Unit,
) {
    when(searchWidgetState) {
        SearchWidgetState.CLOSED -> {
            DefaultAppBar(
                title = titleState,
                onSearchClicked = onSearchTriggered
            )
        }
        SearchWidgetState.OPENED -> {
            SearchAppBar(
                text = searchTextState,
                onTextChange = onTextChange,
                onCloseClicked = onCloseClicked,
                onSearchClicked = onSearchClicked,
            )
        }
    }
}