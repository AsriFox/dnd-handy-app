package com.example.dndhandy.api.article

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontStyle
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import org.json.JSONArray

@Composable
fun ApiArticleScreen(
    category: String,
    descParagraphs: Collection<String>
) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(5.dp)
            .verticalScroll(
                state = rememberScrollState(),
            ),
        verticalArrangement = Arrangement.spacedBy(5.dp)
    ) {
        descParagraphs.forEach {
            Text(
                text = it,
                textAlign = TextAlign.Justify,
            )
        }
        Text(
            text = "Category: $category",
            fontStyle = FontStyle.Italic,
        )
    }
}

@Composable
fun ApiArticleScreen(
    category: String,
    desc: String,
) = ApiArticleScreen(
    category,
    listOf(desc)
)

@Composable
fun ApiArticleScreen(
    category: String,
    desc: JSONArray,
) = Array(
        size = desc.length(),
        init = { desc.optString(it) }
    )
    .filterNotNull()
    .let { array ->
        ApiArticleScreen(category, array)
    }

@Preview
@Composable
fun ApiArticleScreenPreviewMultiParagraph() {
    ApiArticleScreen(
        category = "conditions",
        descParagraphs = listOf(
            "- A blinded creature can't see and automatically fails any ability check that requires sight.",
            "- Attack rolls against the creature have advantage, and the creature's attack rolls have disadvantage.",
        )
    )
}

@Preview
@Composable
fun ApiArticleScreenPreviewSingleParagraph() {
    ApiArticleScreen(
        category = "magic schools",
        desc = "Conjuration spells involve the transportation of objects and creatures" +
                " from one location to another. Some spells summon creatures or objects" +
                " to the caster's side, whereas others allow the caster to teleport to" +
                " another location. Some conjurations create objects or effects out of nothing."
    )
}