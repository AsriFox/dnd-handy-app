package com.example.dndhandy

import androidx.compose.runtime.MutableState
import androidx.compose.runtime.State
import androidx.compose.runtime.mutableStateOf
import androidx.lifecycle.ViewModel
import com.example.dndhandy.search.SearchWidgetState

class MainViewModel : ViewModel() {

    // TitleState
    private val _titleState: MutableState<String> =
        mutableStateOf("Handy DnD database")
    val titleState: State<String> = _titleState

    fun updateTitleState(newValue: String) {
        _titleState.value = newValue
    }

    // SearchWidgetState
    private val _searchWidgetState: MutableState<SearchWidgetState> =
        mutableStateOf(value = SearchWidgetState.CLOSED)
    val searchWidgetState: State<SearchWidgetState> = _searchWidgetState

    fun updateSearchWidgetState(newValue: SearchWidgetState) {
        _searchWidgetState.value = newValue
    }

    // SearchTextState
    private val _searchTextState: MutableState<String> =
        mutableStateOf(value = "")
    val searchTextState: State<String> = _searchTextState

    fun updateSearchTextState(newValue: String) {
        _searchTextState.value = newValue
    }
}