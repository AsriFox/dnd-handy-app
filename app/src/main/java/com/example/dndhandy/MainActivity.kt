package com.example.dndhandy

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.viewModels
import androidx.compose.material.Scaffold
import androidx.compose.material.Text
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.navigation.navArgument
import com.example.dndhandy.api.ApiNullScreen
import com.example.dndhandy.api.ApiScreen
import com.example.dndhandy.search.SearchViewModel
import com.example.dndhandy.search.SearchWidgetState
import com.example.dndhandy.ui.theme.DndHandyTheme

class MainActivity : ComponentActivity() {

    private val searchViewModel: SearchViewModel by viewModels()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            DndHandyTheme {
                val navController = rememberNavController()

                Scaffold(
                    topBar = {
                        val searchWidgetState by searchViewModel.searchWidgetState
                        val searchTextState by searchViewModel.searchTextState

                        MainAppBar(
                            searchWidgetState,
                            searchTextState,
                            onTextChange = {
                                searchViewModel.updateSearchTextState(newValue = it)
                            },
                            onCloseClicked = {
                                searchViewModel.updateSearchTextState(newValue = "")
                                searchViewModel.updateSearchWidgetState(SearchWidgetState.CLOSED)
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
                                searchViewModel.updateSearchWidgetState(SearchWidgetState.OPENED)
                            },
                        )
                    }
                ) {
                    NavHost(
                        navController = navController,
                        startDestination = "api"
                    ) {
                        composable("api") {
                            Text(text = "Welcome!")
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
                                        navController = navController,
                                        requestPath = it.replace('.', '/'),
                                    )
                                } ?: ApiNullScreen("null")
                        }
                    }
                }
            }
        }
    }
}