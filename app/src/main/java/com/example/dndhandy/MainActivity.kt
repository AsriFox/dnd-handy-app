package com.example.dndhandy

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.viewModels
import androidx.compose.material.MaterialTheme
import androidx.compose.material.Scaffold
import androidx.compose.material.Text
import androidx.compose.runtime.getValue
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.navigation.navArgument
import com.example.dndhandy.api.ApiNullScreen
import com.example.dndhandy.api.ApiScreen
import com.example.dndhandy.search.SearchWidgetState
import com.example.dndhandy.ui.theme.DndHandyTheme

class MainActivity : ComponentActivity() {

    private val mainViewModel: MainViewModel by viewModels()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            DndHandyTheme {
                val navController = rememberNavController()

                Scaffold(
                    topBar = {
                        val titleState by mainViewModel.titleState
                        val searchWidgetState by mainViewModel.searchWidgetState
                        val searchTextState by mainViewModel.searchTextState

                        MainAppBar(
                            titleState,
                            searchWidgetState,
                            searchTextState,
                            onTextChange = {
                                mainViewModel.updateSearchTextState(newValue = it)
                            },
                            onCloseClicked = {
                                mainViewModel.updateSearchTextState(newValue = "")
                                mainViewModel.updateSearchWidgetState(SearchWidgetState.CLOSED)
                            },
                            onSearchClicked = {
                                navController.navigate(
                                    route = searchTextState
                                        .ifBlank { null }
                                        ?.let {
                                            "api/$searchTextState"
                                                .replace('/', '.')
                                        }
                                        ?: "api"
                                )
                            },
                            onSearchTriggered = {
                                mainViewModel.updateSearchWidgetState(SearchWidgetState.OPENED)
                            },
                        )
                    }
                ) {
                    NavHost(
                        navController,
                        startDestination = "api"
                    ) {
                        composable("api") {
                            mainViewModel.updateTitleState(newValue = "Handy DnD database")

                            Text(
                                text = "Welcome!",
                                fontSize = MaterialTheme.typography.h3.fontSize,
                            )
                        }

                        composable(
                            "{url}",
                            arguments = listOf(
                                navArgument("url") {
                                    type = NavType.StringType
                                }
                            )
                        ) { nav ->
                            nav.arguments?.getString("url")
                                ?.let {
                                    ApiScreen(
                                        requestPath = it.replace('.', '/'),
                                        navController,
                                        mainViewModel,
                                    )
                                } ?: ApiNullScreen("null")
                        }
                    }
                }
            }
        }
    }
}