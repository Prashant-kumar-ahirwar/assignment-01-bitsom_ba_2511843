#  Embedding & Similarity

## 1. Sentences (Total 10)

### Cricket

1. The bowler delivered a fast yorker that clean bowled the batsman.
2. The captain set an aggressive field to stop the runs.
3. The batsman scored a brilliant century in the final match.
4. The spinner confused the batsman with a sharp turning delivery.

### Cooking

5. The chef added fresh herbs to enhance the flavor of the soup.
6. Baking a cake requires precise measurements of ingredients.
7. The vegetables were sautéed in olive oil and garlic.

### Cybersecurity

8. Strong passwords help protect online accounts from hackers.
9. A firewall blocks unauthorized access to a computer network.
10. Encryption secures sensitive information during data transmission.

---

## 2. Generating Embeddings

```python
!pip install sentence-transformers

from sentence_transformers import SentenceTransformer
import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

model = SentenceTransformer('all-MiniLM-L6-v2')

sentences = [
"The bowler delivered a fast yorker that clean bowled the batsman.",
"The captain set an aggressive field to stop the runs.",
"The batsman scored a brilliant century in the final match.",
"The spinner confused the batsman with a sharp turning delivery.",
"The chef added fresh herbs to enhance the flavor of the soup.",
"Baking a cake requires precise measurements of ingredients.",
"The vegetables were sautéed in olive oil and garlic.",
"Strong passwords help protect online accounts from hackers.",
"A firewall blocks unauthorized access to a computer network.",
"Encryption secures sensitive information during data transmission."
]

embeddings = model.encode(sentences)
```

---

## 3. Cosine Similarity Matrix

Cosine similarity measures how similar two sentences are.

```python
from sklearn.metrics.pairwise import cosine_similarity

similarity_matrix = cosine_similarity(embeddings)
print(similarity_matrix)
```

---

## 4. Heatmap Visualization

```python
plt.figure(figsize=(8,6))
sns.heatmap(similarity_matrix, annot=True, cmap="coolwarm")
plt.title("Sentence Similarity Heatmap")
plt.show()
```

---

## 5. Query Similarity

Query:

"The bowler took three wickets in one over"

```python
query = "The bowler took three wickets in one over"
query_embedding = model.encode([query])

scores = cosine_similarity(query_embedding, embeddings)[0]

top2_idx = np.argsort(scores)[-2:][::-1]

for idx in top2_idx:
    print(sentences[idx], "-> Similarity:", scores[idx])
```

---

## 6. Explanation

Embeddings convert text into numerical vectors that capture semantic meaning. Sentences with similar meanings have vectors that are close to each other. Cosine similarity is used to measure how close these vectors are. A value closer to 1 means the sentences are very similar.

In this task, sentences from the same topic (Cricket, Cooking, Cybersecurity) will have higher similarity among themselves. The heatmap visually represents this clustering.

When we input a query sentence, it is also converted into a vector. The system then compares it with all sentence vectors and returns the most similar ones. This helps in finding relevant information even if the wording is different.

---

## 7. Vector Database Use Cases

A traditional keyword-based database search is not sufficient for searching complex legal contracts. Keyword search only matches exact words present in the document. For example, if a lawyer searches for “termination clauses,” the system will only return documents containing those exact words. However, legal documents often use varied language such as “agreement cancellation conditions” or “contract ending provisions.” In such cases, keyword search may fail to retrieve relevant results.

A vector database solves this problem using embeddings. Each section of the contract is converted into a vector representation that captures its meaning. When a lawyer enters a query in plain English, it is also converted into a vector. The system then finds sections with similar meanings using cosine similarity.

This allows the system to understand context and intent rather than exact wording. Even if different phrases are used, relevant results can still be retrieved. Vector databases are optimized for fast similarity searches, making them suitable for large documents like 500-page contracts.

Therefore, using embeddings and vector databases provides more accurate and intelligent search results compared to traditional keyword-based systems.
