package com.example.dndhandy

import androidx.compose.material.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Menu
import androidx.compose.material.icons.filled.Search
import androidx.compose.runtime.Composable
import androidx.compose.ui.tooling.preview.Preview
import com.example.dndhandy.ui.theme.DndHandyTheme

@Composable
fun DefaultAppBar(onSearchClicked: () -> Unit) {
    TopAppBar (
        title = {
            Text(text = "Handy DnD database")
        },
        navigationIcon = {
            IconButton(onClick = { /*TODO*/ }) {
                Icon(
                    imageVector = Icons.Filled.Menu,
                    contentDescription = "Menu"
                )
            }
        },
        actions = {
            IconButton(
                onClick = { onSearchClicked() }
            ) {
                Icon(
                    imageVector = Icons.Filled.Search,
                    contentDescription = "Search"
                )
            }
        },
        backgroundColor = MaterialTheme.colors.primary
    )
}

@Preview(showBackground = true)
@Composable
fun DefaultAppBarPreview() {
    DndHandyTheme {
        DefaultAppBar(onSearchClicked = {})
    }
}