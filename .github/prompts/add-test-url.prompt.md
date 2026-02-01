---
agent: 'agent'
description: 'Add test url'
---

text: ${input:url:paste site url here}

fetch the html from the provided url.
create a folder under test/test_data/ with the domain name (including TLD) as the folder name if it doesn't already exist.
write the html content to a new file named <domain_name without dot and tld>_1.testhtml inside that folder. use _2, _3 etc if a file with that name already exists.
write a json file named <domain_name without dot and tld>_1.json alongside the html file, with the following structure:
```json
{
  "author": "<found author>",
  "canonical_url": "<provided url>",
  "site_name": "<extracted site name>",
  "host": "<extracted host>",
  "language": "<extracted language>",
  "title": "<extracted title>",
  "ingredients": [
    "list of found ingredients"
  ],
  "instructions_list": [
    "list of found instructions steps"
  ],
  "category": "<category if found>",
  "yields": "<number of servings if found>",
  "total_time": "<total time if found>",
  "cook_time": "<cook time if found>",
  "prep_time": "<prep time if found>",
  "cuisine": "<cuisine if found>",
  "ratings": <average rating as a number>,
  "ratings_count": <number of ratings as a number>,
  "image": "<extracted image URL>",
  "video": "<extracted video URL>",
  "keywords": [
    "list of found keywords"
  ],
  "description": "<extracted description>"
}
```

add the domain to utils/recipe_scrapers/scraper_fatory.dart map, with AbstractScraper, if not yet present.
add the domain to test/scrapers_test.dart list, with AbstractScraper, if not yet present.
add the url to the README.md file in supported sites list.
Put it in France section if recipe is in French, else put it in Other section.
