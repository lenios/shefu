import 'package:material_ui/material_ui.dart';

/// Names of the ingredients having an icon (`assets/icons/nutrients/<key>.svg`),
/// in English, French, Hungarian and Japanese; `|` separates the spellings
/// (singular, plural...) that an ingredient name must equal, ignoring case.
const ingredientIconNames = <String, List<String>>{
  // Fruits
  'apple': ['apple|apples', 'pomme|pommes', 'alma', 'りんご|リンゴ'],
  'apricot': ['apricot|apricots', 'abricot|abricots', 'sárgabarack', 'アプリコット|杏'],
  'avocado': ['avocado|avocados', 'avocat|avocats', 'avokádó', 'アボカド'],
  'banana': ['banana|bananas', 'banane|bananes', 'banán', 'バナナ'],
  'blackberry': ['blackberry|blackberries', 'mûre|mûres', 'szeder', 'ブラックベリー'],
  'blueberry': ['blueberry|blueberries', 'myrtille|myrtilles', 'áfonya', 'ブルーベリー'],
  'carambola': ['star fruit|carambola', 'carambole|caramboles', 'csillaggyümölcs', 'スターフルーツ'],
  'cherry': ['cherry|cherries', 'cerise|cerises', 'cseresznye', 'さくらんぼ|チェリー'],
  'clementine': [
    'clementine|clementines|mandarin|mandarins',
    'clémentine|clémentines|mandarine|mandarines',
    'mandarin',
    'みかん',
  ],
  'coconut': ['coconut', 'noix de coco|coco', 'kókuszdió', 'ココナッツ'],
  'cranberry': [
    'cranberry|cranberries',
    'canneberge|canneberges|cranberry|cranberries',
    'vörös áfonya',
    'クランベリー',
  ],
  'date': ['date|dates', 'datte|dattes', 'datolya', 'デーツ'],
  'dragon-fruit': ['dragon fruit', 'fruit du dragon|pitaya', 'sárkánygyümölcs', 'ドラゴンフルーツ'],
  'fig': ['fig|figs', 'figue|figues', 'füge', 'イチジク|いちじく'],
  'grapefruit': ['grapefruit|grapefruits', 'pamplemousse|pamplemousses', 'grapefruit', 'グレープフルーツ'],
  'grapes': ['grape|grapes', 'raisin|raisins', 'szőlő', 'ブドウ|ぶどう'],
  'kiwi': ['kiwi|kiwis', 'kiwi|kiwis', 'kiwi', 'キウイ'],
  'lemon': ['lemon|lemons', 'citron|citrons', 'citrom', 'レモン'],
  'lime': ['lime|limes', 'citron vert|citrons verts|lime|limes', 'lime', 'ライム'],
  'lychee': ['lychee|lychees', 'litchi|litchis', 'licsi', 'ライチ'],
  'mango': ['mango|mangoes', 'mangue|mangues', 'mangó', 'マンゴー'],
  'melon': ['melon|melons', 'melon|melons', 'sárgadinnye|dinnye', 'メロン'],
  'orange': ['orange|oranges', 'orange|oranges', 'narancs', 'オレンジ'],
  'passion-fruit': [
    'passion fruit|passion fruits',
    'fruit de la passion|fruits de la passion',
    'maracuja',
    'パッションフルーツ',
  ],
  'papaya': ['papaya|papayas', 'papaye|papayes', 'papaya', 'パパイヤ'],
  'peach': ['peach|peaches', 'pêche|pêches', 'őszibarack', '桃|もも'],
  'pear': ['pear|pears', 'poire|poires', 'körte', '梨|洋梨'],
  'pineapple': ['pineapple|pineapples', 'ananas', 'ananász', 'パイナップル'],
  'plum': ['plum|plums', 'prune|prunes', 'szilva', 'プラム'],
  'pomegranate': ['pomegranate|pomegranates', 'grenade|grenades', 'gránátalma', 'ザクロ'],
  'prune': ['prune|prunes', 'pruneau|pruneaux', 'aszalt szilva', 'プルーン'],
  'raisin': ['raisin|raisins', 'raisin sec|raisins secs', 'mazsola', 'レーズン'],
  'raspberry': ['raspberry|raspberries', 'framboise|framboises', 'málna', 'ラズベリー'],
  'red-currant': [
    'red currant|red currants|redcurrants',
    'groseille|groseilles',
    'ribizli',
    '赤すぐり',
  ],
  'rhubarb': ['rhubarb', 'rhubarbe', 'rebarbara', 'ルバーブ'],
  'strawberry': ['strawberry|strawberries', 'fraise|fraises', 'eper', 'イチゴ|いちご'],
  'watermelon': ['watermelon|watermelons', 'pastèque|pastèques', 'görögdinnye', 'スイカ'],
  // Vegetables
  'asparagus': ['asparagus', 'asperge|asperges', 'spárga', 'アスパラガス'],
  'beet': ['beet|beets|beetroot|beetroots', 'betterave|betteraves', 'cékla', 'ビーツ'],
  'bell-pepper': [
    'bell pepper|bell peppers',
    'poivron|poivrons',
    'kaliforniai paprika',
    'ピーマン|パプリカ',
  ],
  'bok-choy': ['bok choy|pak choi', 'pak choï|bok choy', 'pak choi', 'チンゲン菜|青梗菜'],
  'broccoli': ['broccoli', 'brocoli|brocolis', 'brokkoli', 'ブロッコリー'],
  'brussels-sprouts': [
    'brussels sprouts|brussels sprout',
    'chou de bruxelles|choux de bruxelles',
    'kelbimbó',
    '芽キャベツ',
  ],
  'cabbage': ['cabbage|cabbages', 'chou|choux', 'káposzta', 'キャベツ'],
  'capers': ['caper|capers', 'câpre|câpres', 'kapribogyó', 'ケッパー'],
  'carrot': ['carrot|carrots', 'carotte|carottes', 'sárgarépa|répa', 'ニンジン|人参|にんじん'],
  'cauliflower': ['cauliflower', 'chou-fleur|choux-fleurs', 'karfiol', 'カリフラワー'],
  'celery': ['celery', 'céleri|céleri branche', 'zeller', 'セロリ'],
  'corn': ['corn|sweet corn', 'maïs', 'kukorica', 'トウモロコシ|コーン'],
  'cucumber': ['cucumber|cucumbers', 'concombre|concombres', 'uborka', 'キュウリ|きゅうり'],
  'eggplant': [
    'eggplant|eggplants|aubergine|aubergines',
    'aubergine|aubergines',
    'padlizsán',
    'ナス|なす',
  ],
  'garlic': [
    'garlic|garlic clove|garlic cloves',
    'ail|gousse d\'ail|gousses d\'ail',
    'fokhagyma',
    'ニンニク|にんにく',
  ],
  'green-beans': [
    'green bean|green beans',
    'haricot vert|haricots verts',
    'zöldbab',
    'インゲン|さやいんげん',
  ],
  'green-onion': [
    'green onion|green onions|scallion|scallions|spring onion|spring onions',
    'oignon nouveau|oignons nouveaux|ciboule',
    'újhagyma',
    '長ねぎ|ねぎ|青ねぎ',
  ],
  'leek': ['leek|leeks', 'poireau|poireaux', 'póréhagyma', 'リーク|ポロネギ'],
  'lettuce': ['lettuce|lettuces', 'laitue|laitues|salade', 'saláta', 'レタス'],
  'mushroom': ['mushroom|mushrooms', 'champignon|champignons', 'gomba', 'キノコ|きのこ|マッシュルーム'],
  'olive': ['olive|olives', 'olive|olives', 'olívabogyó|olíva', 'オリーブ'],
  'onion': ['onion|onions', 'oignon|oignons', 'hagyma|vöröshagyma', '玉ねぎ|たまねぎ|玉葱'],
  'parsnip': ['parsnip|parsnips', 'panais', 'paszternák', 'パースニップ'],
  'peas': ['pea|peas', 'petit pois|petits pois', 'borsó|zöldborsó', 'エンドウ豆|グリーンピース'],
  'potato': [
    'potato|potatoes',
    'pomme de terre|pommes de terre',
    'burgonya|krumpli',
    'ジャガイモ|じゃがいも',
  ],
  'pumpkin': [
    'pumpkin|pumpkins|squash',
    'potiron|potirons|citrouille|courge',
    'tök|sütőtök',
    'カボチャ|かぼちゃ',
  ],
  'radish': ['radish|radishes', 'radis', 'retek', '大根|ラディッシュ'],
  'shallot': ['shallot|shallots', 'échalote|échalotes', 'mogyoróhagyma|salottahagyma', 'エシャロット'],
  'spinach': ['spinach', 'épinard|épinards', 'spenót', 'ほうれん草'],
  'sweet-potato': [
    'sweet potato|sweet potatoes',
    'patate douce|patates douces',
    'édesburgonya|batáta',
    'サツマイモ|さつまいも',
  ],
  'tomato': ['tomato|tomatoes', 'tomate|tomates', 'paradicsom', 'トマト'],
  'turnip': ['turnip|turnips', 'navet|navets', 'fehérrépa|tarlórépa', 'かぶ|カブ'],
  'zucchini': [
    'zucchini|zucchinis|courgette|courgettes',
    'courgette|courgettes',
    'cukkini',
    'ズッキーニ',
  ],
  // Herbs and spices
  'basil': ['basil', 'basilic', 'bazsalikom', 'バジル'],
  'bay-leaf': [
    'bay leaf|bay leaves',
    'laurier|feuille de laurier|feuilles de laurier',
    'babérlevél',
    'ローリエ',
  ],
  'chili-pepper': [
    'chili|chilies|chili pepper|chili peppers|chilli',
    'piment|piments',
    'chili|csilipaprika',
    '唐辛子|とうがらし',
  ],
  'cinnamon': ['cinnamon', 'cannelle', 'fahéj', 'シナモン'],
  'cloves': ['clove|cloves', 'clou de girofle|clous de girofle', 'szegfűszeg', 'クローブ'],
  'cumin': ['cumin', 'cumin', 'kömény|római kömény', 'クミン'],
  'curry': ['curry|curry powder', 'curry|poudre de curry', 'curry|curry por', 'カレー粉'],
  'mint': ['mint', 'menthe', 'menta', 'ミント'],
  'oregano': ['oregano', 'origan', 'oregánó', 'オレガノ'],
  'paprika': [
    'paprika|smoked paprika',
    'paprika|paprika fumé',
    'fűszerpaprika|pirospaprika',
    'パプリカパウダー',
  ],
  'rosemary': ['rosemary', 'romarin', 'rozmaring', 'ローズマリー'],
  'sage': ['sage', 'sauge', 'zsálya', 'セージ'],
  'salt': ['salt|sea salt', 'sel|fleur de sel|gros sel', 'só', '塩'],
  'sesame-seeds': ['sesame|sesame seeds', 'sésame|graines de sésame', 'szezámmag', 'ごま|ゴマ'],
  'turmeric': ['turmeric', 'curcuma', 'kurkuma', 'ターメリック'],
  'vanilla': [
    'vanilla|vanilla extract|vanilla bean|vanilla pod',
    'vanille|extrait de vanille|gousse de vanille',
    'vanília',
    'バニラ',
  ],
  // Pantry
  'brown-sugar': [
    'brown sugar',
    'sucre roux|cassonade|vergeoise',
    'barna cukor|nádcukor',
    'きび砂糖|三温糖',
  ],
  'coconut-milk': ['coconut milk', 'lait de coco', 'kókusztej', 'ココナッツミルク'],
  'gelatin': ['gelatin|gelatine', 'gélatine', 'zselatin', 'ゼラチン'],
  'honey': ['honey', 'miel', 'méz', 'はちみつ|蜂蜜'],
  'jam': ['jam', 'confiture', 'lekvár', 'ジャム'],
  'ketchup': ['ketchup', 'ketchup', 'ketchup', 'ケチャップ'],
  'mayonnaise': ['mayonnaise|mayo', 'mayonnaise', 'majonéz', 'マヨネーズ'],
  'mustard': ['mustard|dijon mustard', 'moutarde|moutarde de dijon', 'mustár', 'マスタード|からし'],
  'olive-oil': ['olive oil', "huile d'olive", 'olívaolaj', 'オリーブ油|オリーブオイル'],
  'soy-sauce': ['soy sauce', 'sauce soja', 'szójaszósz', '醤油|しょうゆ'],
  'sugar': [
    'sugar|caster sugar|granulated sugar|white sugar',
    'sucre|sucre en poudre|sucre semoule',
    'cukor|kristálycukor',
    '砂糖',
  ],
  'tomato-paste': [
    'tomato paste|tomato puree|tomato purée',
    'concentré de tomate|coulis de tomate',
    'paradicsompüré|sűrített paradicsom',
    'トマトペースト',
  ],
  'vegetable-oil': [
    'oil|vegetable oil|sunflower oil|canola oil|neutral oil',
    'huile|huile végétale|huile de tournesol|huile neutre',
    'olaj|étolaj|napraforgóolaj',
    '油|サラダ油|植物油',
  ],
  'vinegar': [
    'vinegar|wine vinegar|balsamic vinegar|cider vinegar',
    'vinaigre|vinaigre balsamique|vinaigre de vin|vinaigre de cidre',
    'ecet|balzsamecet',
    '酢',
  ],
  'water': [
    'water|cold water|warm water|hot water',
    'eau|eau froide|eau tiède|eau chaude',
    'víz|hideg víz|langyos víz',
    '水|お湯|湯',
  ],
  'yeast': [
    'yeast|dry yeast|instant yeast',
    'levure|levure boulangère|levure de boulanger',
    'élesztő',
    'イースト|ドライイースト',
  ],
  // Grains and legumes
  'bread': ['bread|loaf|baguette', 'pain|baguette', 'kenyér', 'パン|食パン'],
  'kidney-beans': [
    'kidney bean|kidney beans|red beans',
    'haricot rouge|haricots rouges',
    'vörösbab',
    'キドニービーンズ|金時豆',
  ],
  'spaghetti': ['spaghetti|linguine', 'spaghetti|spaghettis|linguine', 'spagetti', 'スパゲッティ'],
  'tortilla': [
    'tortilla|tortillas|wrap|wraps',
    'tortilla|tortillas|galette de blé',
    'tortilla',
    'トルティーヤ',
  ],
  'white-beans': [
    'white bean|white beans|cannellini beans|navy beans',
    'haricot blanc|haricots blancs|lingots',
    'fehérbab',
    '白いんげん豆',
  ],
  // Nuts and seeds
  'almond': [
    'almond|almonds|ground almonds',
    'amande|amandes|poudre d\'amande',
    'mandula',
    'アーモンド',
  ],
  'cashew': ['cashew|cashews', 'noix de cajou', 'kesudió', 'カシューナッツ'],
  'chestnut': ['chestnut|chestnuts', 'châtaigne|châtaignes|marron|marrons', 'gesztenye', '栗|くり'],
  'hazelnut': ['hazelnut|hazelnuts', 'noisette|noisettes', 'mogyoró|törökmogyoró', 'ヘーゼルナッツ'],
  'pine-nut': ['pine nut|pine nuts', 'pignon|pignons|pignons de pin', 'fenyőmag', '松の実'],
  'sunflower-seeds': ['sunflower seeds', 'graines de tournesol', 'napraforgómag', 'ひまわりの種'],
  'walnut': ['walnut|walnuts', 'noix|cerneaux de noix', 'dió', 'くるみ|クルミ'],
  // Dairy and eggs
  'butter': [
    'butter|unsalted butter|salted butter',
    'beurre|beurre doux|beurre demi-sel',
    'vaj',
    'バター',
  ],
  'chocolate-dark': [
    'dark chocolate|chocolate',
    'chocolat noir|chocolat|chocolat pâtissier',
    'étcsokoládé|csokoládé',
    'ダークチョコレート|チョコレート',
  ],
  'chocolate-milk': ['milk chocolate', 'chocolat au lait', 'tejcsokoládé', 'ミルクチョコレート'],
  'chocolate-ruby': ['ruby chocolate', 'chocolat ruby', 'rubincsokoládé', 'ルビーチョコレート'],
  'chocolate-white': ['white chocolate', 'chocolat blanc', 'fehércsokoládé', 'ホワイトチョコレート'],
  'egg': [
    'egg|eggs|egg yolk|egg yolks|egg white|egg whites',
    'oeuf|oeufs|œuf|œufs|jaune d\'oeuf|jaunes d\'oeufs|blanc d\'oeuf|blancs d\'oeufs',
    'tojás|tojássárgája|tojásfehérje',
    '卵|たまご|卵黄|卵白',
  ],
  'goat-cheese': ['goat cheese', 'fromage de chèvre|chèvre', 'kecskesajt', '山羊チーズ'],
  'milk': ['milk|whole milk', 'lait|lait entier|lait demi-écrémé', 'tej', '牛乳|ミルク'],
  'mozzarella': ['mozzarella', 'mozzarella', 'mozzarella', 'モッツァレラ'],
  'parmesan': ['parmesan|parmigiano', 'parmesan', 'parmezán', 'パルメザンチーズ|粉チーズ'],
  'sour-cream': ['sour cream|crème fraîche', 'crème fraîche|crème épaisse', 'tejföl', 'サワークリーム'],
  // Meat
  'bacon': ['bacon', 'lardons|bacon|poitrine fumée', 'bacon|szalonna', 'ベーコン'],
  'chicken': [
    'chicken|chicken breast|chicken breasts|chicken thighs',
    'poulet|blanc de poulet|blancs de poulet|cuisses de poulet',
    'csirke|csirkemell',
    '鶏肉|鶏むね肉|鶏もも肉',
  ],
  'ground-beef': [
    'ground beef|minced beef|minced meat|ground meat',
    'boeuf haché|bœuf haché|viande hachée|steak haché',
    'darált hús|darált marhahús',
    '合いびき肉|ひき肉',
  ],
  'ham': ['ham', 'jambon', 'sonka', 'ハム'],
  'lamb': ['lamb', 'agneau', 'bárány|bárányhús', 'ラム肉'],
  'pork': [
    'pork|pork chop|pork chops|pork loin',
    'porc|filet mignon de porc|échine de porc',
    'sertéshús|sertés',
    '豚肉',
  ],
  'sausage': ['sausage|sausages|chorizo', 'saucisse|saucisses|chorizo', 'kolbász|virsli', 'ソーセージ'],
  'turkey': ['turkey|turkey breast', 'dinde|escalope de dinde', 'pulyka|pulykamell', '七面鳥'],
  'veal': ['veal', 'veau', 'borjúhús|borjú', '仔牛肉'],
  // Fish and seafood
  'anchovy': ['anchovy|anchovies', 'anchois', 'szardella', 'アンチョビ'],
  'crab': ['crab|crab meat', 'crabe|chair de crabe', 'rák|tarisznyarák', 'カニ|かに'],
  'lobster': ['lobster', 'homard|langouste', 'homár', 'ロブスター|伊勢海老'],
  'mussels': ['mussel|mussels', 'moule|moules', 'kagyló|fekete kagyló', 'ムール貝'],
  'salmon': [
    'salmon|salmon fillet|smoked salmon',
    'saumon|pavé de saumon|saumon fumé',
    'lazac',
    '鮭|サーモン',
  ],
  'sardine': ['sardine|sardines', 'sardine|sardines', 'szardínia', 'いわし|イワシ'],
  'scallop': [
    'scallop|scallops',
    'saint-jacques|noix de saint-jacques|coquilles saint-jacques',
    'fésűkagyló',
    'ホタテ|帆立',
  ],
  'squid': ['squid|calamari', 'calamar|calamars|encornet|encornets', 'tintahal|kalmár', 'イカ|いか'],
  'trout': ['trout', 'truite', 'pisztráng', 'マス|鱒'],
  // Others
  'seaweed': [
    'seaweed|nori|kombu|wakame',
    'algue|algues|nori|kombu|wakamé',
    'tengeri alga|nori',
    '海苔|のり|昆布|わかめ',
  ],
};

/// Kitchen equipment having an icon: its asset (`assets/icons/<key>.svg`) or a
/// Material icon, and words of an instruction that call for it, in English,
/// French, Hungarian and Japanese (`|` separates the words).
final equipmentIcons = <String, ({Object icon, List<String> names})>{
  'blender': (
    icon: Icons.blender_outlined,
    names: ['blender|blend', 'blender|mixeur|mixez|mixer', 'turmixgép|turmixold', 'ブレンダー'],
  ),
  'bowl': (icon: 'bowl', names: ['bowl', 'saladier|bol|cul-de-poule', 'tál|keverőtál', 'ボウル']),
  'cake-pan': (
    icon: 'cake-pan',
    names: [
      'cake pan|cake tin|springform|mold|mould',
      'moule|moule à gâteau|moule à manqué|cercle',
      'tortaforma|sütőforma',
      'ケーキ型|型',
    ],
  ),
  'colander': (
    icon: 'colander',
    names: ['colander|drain', 'passoire|égouttez|égoutter', 'szűrő|szűrd le', 'ざる|ザル'],
  ),
  'deep-fryer': (
    icon: 'deep-fryer',
    names: [
      'deep fryer|deep-fry|deep fry|fryer',
      'friteuse|bain de friture',
      'olajsütő|bő olaj',
      'フライヤー|揚げ',
    ],
  ),
  'freezer': (
    icon: 'freezer',
    names: ['freezer|freeze', 'congélateur|congeler|congelez', 'fagyasztó|fagyaszd', '冷凍庫|冷凍'],
  ),
  'fridge': (
    icon: 'fridge',
    names: [
      'fridge|refrigerator|refrigerate|chill',
      'réfrigérateur|frigo|frigidaire',
      'hűtőszekrény|hűtő|hűtőbe',
      '冷蔵庫|冷やす',
    ],
  ),
  'grater': (
    icon: 'grater',
    names: [
      'grater|grate|zester',
      'râpe|râpez|râper|zesteur',
      'reszelő|reszeld|reszelve',
      'おろし器|すりおろす|おろす',
    ],
  ),
  'kitchen-scale': (
    icon: 'kitchen-scale',
    names: [
      'kitchen scale|scale|weigh',
      'balance|pesez|peser',
      'konyhai mérleg|mérleg|mérd le',
      'はかり|スケール|計量',
    ],
  ),
  'knife': (
    icon: 'knife',
    names: [
      'cut|knife|slice|chop|dice',
      'couper|coupez|couteau|émincez|hachez|tranchez',
      'vágd|kés|szeleteld|aprítsd',
      '切る|包丁|切り',
    ],
  ),
  'microwave': (
    icon: Icons.microwave_outlined,
    names: ['microwave', 'micro-ondes|micro-onde', 'mikró|mikrohullámú sütő', '電子レンジ|レンジ'],
  ),
  'mixer': (
    icon: 'mixer',
    names: [
      'mixer|stand mixer|electric mixer|hand mixer',
      'robot|batteur|robot pâtissier|batteur électrique',
      'mixer|robotgép|kézi mixer',
      'ミキサー|ハンドミキサー',
    ],
  ),
  'mortar': (
    icon: 'mortar',
    names: ['mortar|pestle|mortar and pestle', 'mortier|pilon|pilez', 'mozsár', 'すり鉢'],
  ),
  'oven': (
    icon: 'oven-outline',
    names: [
      'oven|bake|preheat',
      'four|préchauffez|enfournez|enfourner',
      'sütő|süsd|előmelegített',
      'オーブン',
    ],
  ),
  'paddle': (
    icon: 'paddle',
    names: ['spatula|rubber spatula', 'maryse|spatule', 'spatula|szilikon spatula', 'ヘラ|ゴムベラ'],
  ),
  'parchment-paper': (
    icon: 'parchment-paper',
    names: [
      'parchment paper|parchment|baking paper',
      'papier sulfurisé|papier cuisson',
      'sütőpapír',
      'クッキングシート|オーブンシート',
    ],
  ),
  'piping-bag': (
    icon: 'piping-bag',
    names: ['piping bag|pastry bag|pipe', 'poche à douille|douille', 'habzsák|nyomózsák', '絞り袋'],
  ),
  'pot': (
    icon: 'cooking-pot',
    names: [
      'pot|saucepan|stockpot|dutch oven',
      'casserole|marmite|faitout|cocotte',
      'fazék|lábas|edény',
      '鍋',
    ],
  ),
  'pressure-cooker': (
    icon: 'pressure-cooker',
    names: ['pressure cooker|instant pot', 'autocuiseur|cocotte-minute', 'kukta|gyorsfőző', '圧力鍋'],
  ),
  'rolling-pin': (
    icon: 'rolling-pin',
    names: [
      'rolling pin|roll out',
      'rouleau|rouleau à pâtisserie|abaissez|étalez',
      'nyújtófa|nyújtsd ki',
      'めん棒|麺棒',
    ],
  ),
  'skillet': (
    icon: 'skillet_24',
    names: ['skillet|frying pan|sauté pan', 'poêle|sauteuse', 'serpenyő', 'フライパン'],
  ),
  'steamer': (
    icon: 'steamer',
    names: [
      'steamer|steam',
      'cuit-vapeur|vapeur|panier vapeur',
      'párolóedény|gőzölő|párold',
      '蒸し器|蒸す',
    ],
  ),
  'whisk': (
    icon: 'whisk',
    names: ['whisk|whip', 'fouet|fouettez', 'habverő|habverővel|verd fel', '泡立て器|泡立て|泡立てる'],
  ),
  'rice-cooker': (
    icon: 'rice-cooker',
    names: ['rice cooker', 'cuiseur à riz|autocuiseur à riz', 'rizsfőző', '炊飯器'],
  ),
};

/// Languages of the names above, in order.
const _languages = ['en', 'fr', 'hu', 'ja'];

int _languageIndex(String languageCode) => switch (_languages.indexOf(languageCode)) {
  -1 => 0,
  final index => index,
};

List<String> _split(String names) => [for (final name in names.split('|')) name.toLowerCase()];

/// Ingredient icon keys by name, for each language.
final _ingredientsByName = [
  for (var language = 0; language < _languages.length; language++)
    {
      for (final MapEntry(:key, value: names) in ingredientIconNames.entries)
        for (final name in _split(names[language])) name: key,
    },
];

/// Asset of the icon of the ingredient named [name] (e.g. "carottes"), or
/// null. Names of [languageCode] win over the same name in another language
/// ("raisins": grapes in French, dried grapes in English).
String? ingredientIconAsset(String name, {String languageCode = 'en'}) {
  final lower = name.trim().toLowerCase();
  final preferred = _languageIndex(languageCode);
  final key =
      _ingredientsByName[preferred][lower] ??
      _ingredientsByName.map((byName) => byName[lower]).nonNulls.firstOrNull;
  return key == null ? null : 'assets/icons/nutrients/$key.svg';
}

/// Kitchen equipment called for by an instruction.
typedef Equipment = ({String key, Object icon, String label});

final _equipmentPatterns = [
  for (final language in _languages)
    {
      for (final MapEntry(:key, :value) in equipmentIcons.entries)
        key: RegExp(
          // Japanese has no spaces between words.
          language == 'ja'
              ? _split(value.names[_languages.indexOf(language)]).map(RegExp.escape).join('|')
              : '(?<![\\p{L}\\p{N}])(${_split(value.names[_languages.indexOf(language)]).map(RegExp.escape).join('|')})(?![\\p{L}\\p{N}])',
          caseSensitive: false,
          unicode: true,
        ),
    },
];

/// Equipment named in [instruction], written in [languageCode]; labels are
/// in [labelLanguageCode]. The icon is an asset path or an [IconData].
List<Equipment> equipmentIn(
  String instruction, {
  required String languageCode,
  required String labelLanguageCode,
}) {
  final patterns = _equipmentPatterns[_languageIndex(languageCode)];
  final labelLanguage = _languageIndex(labelLanguageCode);
  return [
    for (final MapEntry(:key, :value) in equipmentIcons.entries)
      if (patterns[key]!.hasMatch(instruction))
        (
          key: key,
          icon: value.icon is String ? 'assets/icons/${value.icon}.svg' : value.icon,
          label: value.names[labelLanguage].split('|').first,
        ),
  ];
}
