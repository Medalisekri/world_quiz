# Testing Overview

The WorldQuiz project includes **30 tests** distributed across **6 test files**. These tests cover model parsing, localization, quiz logic, distractor generation, geospatial distance calculation, and widget rendering. Every test was written to catch a real bug or edge case discovered during development.

To run all tests:

```bash
flutter test
```

---

## Model Tests — `test/models/country_test.dart`
**3 tests**

| # | What it tests |
|---|---------------|
| 1 | A complete API JSON object with nested names, capitals, currencies, languages, and coordinates is correctly parsed into a `Country` model with all fields populated |
| 2 | When the JSON contains only minimum required fields, the parser does not crash and assigns safe default values such as empty lists and zero coordinates |
| 3 | When multiple currencies are returned as a list of maps, all currency names are extracted correctly into a flat list of strings |

> These tests were written because the app crashed offline when the cached data format differed from the API format.

---

## Localization Tests — `test/localization/translations_test.dart`
**6 tests**

| # | What it tests |
|---|---------------|
| 1 | Requesting a key with locale `en` returns the English value |
| 2 | Requesting a key with locale `ar` returns the Arabic value |
| 3 | If an unsupported locale is requested, the system falls back to English instead of crashing |
| 4 | When a key does not exist in any language map, the system returns the key string itself as a fallback |
| 5 | Every key present in English also exists in Arabic |
| 6 | No Arabic values are empty or whitespace-only |

> These tests prevent untranslated UI elements and blank text in the Arabic interface.

---

## Quiz Logic Tests — `test/providers/quiz_logic_test.dart`
**7 tests**

| # | What it tests |
|---|---------------|
| 1 | Percentage calculation returns accurate results — e.g. 8/10 = 80%, 10/10 = 100% |
| 2 | Dividing by zero when total questions is 0 returns `0.0` instead of throwing |
| 3 | Tiered feedback: ≥80% → Genius, 50–79% → Good Job, <50% → Keep Practicing, including boundary values |
| 4 | Answering 3 questions correctly in a row sets the streak counter to 3 |
| 5 | Three correct → one wrong → two correct results in max streak of 3 and current streak of 2 |
| 6 | Timer value is always clamped between 0 and 10 seconds |
| 7 | Timer bar is blue above 3 seconds and switches to red at 3 seconds or below |

> These tests prevent division-by-zero crashes and streak calculation errors.

---

## Distractor Generation Tests — `test/utils/quiz_helper_test.dart`
**7 tests**

| # | What it tests |
|---|---------------|
| 1 | The question generator produces the expected number of questions from the available country pool |
| 2 | The correct answer is always present in the four-option list for every country |
| 3 | No two options in a question are identical |
| 4 | When a continent filter is applied, only countries from that continent appear |
| 5 | If a continent has fewer than 4 countries, the system falls back to using all countries |
| 6 | Capital-mode questions use the country's capital city as the question text |
| 7 | Countries with an empty capital field do not crash the quiz generator |

> These tests protect the core gameplay loop from producing unplayable questions.

---

## Distance Calculation Tests — `test/utils/distance_test.dart`
**5 tests**

| # | What it tests |
|---|---------------|
| 1 | Paris → Berlin distance falls within the expected real-world range of 850–900 km |
| 2 | Distance between a point and itself returns exactly zero |
| 3 | A guess within 800 km of the target is marked correct; a distant guess is marked incorrect |
| 4 | Distance calculations work correctly across the International Date Line (Fiji and Samoa) |
| 5 | North Pole → South Pole returns approximately 20,000 km |

> These tests ensure the map quiz scoring is geographically accurate.

---

## Widget Tests — `test/screens/country_screen_test.dart`
**2 tests**

| # | What it tests |
|---|---------------|
| 1 | A country list item renders the country name and flag icon correctly |
| 2 | When the country list is empty, the screen displays an appropriate empty-state message |

> These tests catch UI regressions without needing to run the full app on an emulator.

---

## Why These Tests Exist

Every test in this suite corresponds to a real bug or edge case encountered during development:

- **Model tests** — prevent the offline crash caused by cache format mismatches
- **Localization tests** — prevent missing Arabic translations
- **Quiz logic tests** — prevent division-by-zero crashes and streak calculation errors
- **Distractor tests** — prevent duplicate options and missing correct answers
- **Distance tests** — prevent incorrect map quiz scoring
- **Widget tests** — catch UI regressions early

Together, these 30 tests form a safety net that ensures previously fixed bugs never reappear.