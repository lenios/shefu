---
agent: 'agent'
description: 'Add test url'
---

@terminal run this: 
url=${input:url:provide url to test}
domain=$(echo $url | awk -F'[/:]' '{print $4}')
dir=${domain##${domain%.*.*}.}
file_prefix=$(echo $dir | awk -F'.' '{print $1}')
// write testhtml, with incremented suffix if file already exists (max 10 tests)
for i in $(seq 1 10); do
if [[ ! -f test/test_data/$dir/${file_prefix}_${i}.testhtml ]]; then
  curl -L -o test/test_data/$dir/${file_prefix}_${i}.testhtml $url
  break
fi
done

write a json file alongside the testhtml file, with the same name but json extension, with the following structure:
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
add the url to the README.md file in supported sites list, and increase the count.
Put it in France section if recipe is in French, else put it in Other section.
