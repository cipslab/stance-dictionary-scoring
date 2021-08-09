# stance-dictionary-scoring
Description
===========
This script implements scoring of stance in Bieber & Finegan (1989). The paper is included in this repo as a pdf. It scores only the "evidence" markers for certainty and doubt because the other features are sentiment related and more modern sentiment analyzers exist.

While Bieber & Finegan used part-of-speech tagging to implement their rules; however, this implementation applies the rules as regex matches. This may amount to a gloss of some of their rules.  For example one of their rules is:
```
it/that (ADV) BE/SEEM______: apparent, clear, definite, plain, sure (frame includes contracted forms)
```
The regex simply looks for the adjectives, and doesn't test whether *any* adverb appears in the indicated pattern. Instead, the approach here was that since this is a certainty rule, certainty adverbs defined in another rule were used for the match.
