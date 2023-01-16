This classifier was trained to detect which commits are bug fixes or not, based on the textual message in the commit.

The model was trained using a dataset described in [this manuscript called "A fine-grained data set and analysis of tangling in bug fixing commits"](https://doi.org/10.1007/s10664-021-10083-5). The dataset can be found also [here on GitHub](https://github.com/sherbold/replication-kit-2020-line-validation). The data for training, containing the annotations regarding whether the commits are bug fixes can be found in this repository.

If you only want to use the trained model, you can simply download the [joblib file](./bugfix_classifier_linearsvc_countvectorizer.joblib) and look at [test_classifier.py](./test_classifier.py) to understand how to use it. This was a LinearSVC model, trained with a CountVectorizer. The following metrics were obtained:

```
                precision    recall  f1-score   support
            0       0.98      0.96      0.97       455
            1       0.96      0.98      0.97       417
     accuracy                           0.97       872
    macro avg       0.97      0.97      0.97       872
 weighted avg       0.97      0.97      0.97       872
```

If you are interested in re-training the model, you can use [train_model.py](./train_model.py). It will read file [commits_annotated.parquet.gzip](commits_annotated.parquet.gzip) and train the LinearSVC model.

Now, if you want to re-run the entire process, you will need to:

1. Download and install the [SmartShark MongoDB database](https://doi.org/10.5281/zenodo.4095238). This requires a MongoDB installation and approximately 1 Tb of free disk space. Instructions are [here](https://github.com/sherbold/replication-kit-2020-line-validation). Download can take a long time (it took more than a week to download it from South America), as well as the process of restoring the database from the downloaded file (it took also almost a week in my machine - a core i7-3770 CPU @ 3.40GHz with no GPU and 12Gb of RAM).
2. With MongoDB running and the SmartShark database restored, execute [save_commits.py](./save_commits.py). This will read data from the database and save it as [commits.parquet.gzip](./commits.parquet.gzip).
3. Execute [merge_commits.py](merge_commits.py). This will read [commits.parquet.gzip](./commits.parquet.gzip) and [hunk_labels.json](./hunk_labels.json) (which is copied from [here](https://github.com/sherbold/replication-kit-2020-line-validation)) and save [commits_annotated.parquet.gzip](./commits_annotated.parquet.gzip). This merge process considers that, if at least three annotators market a commit as a bugfix, it is considered a bug-fixing commit by consensus. This is the same approach adopted in the [original manuscript](https://doi.org/10.1007/s10664-021-10083-5).
4. There are three notebooks with experiments. All three use similar preprocessing using [NLTK](https://www.nltk.org/) and simple randomized downsampling for balancing. They are documented properly to inform which versions of Python and packages were used.
- [find_vectorizer_parameters.ipynb](./find_vectorizer_parameters.ipynb): uses [Auto_ViML](https://github.com/AutoViML/Auto_ViML) to find parameters for TF-IDF vectorization. The notebook also experiments with Auto_ViML's Auto-NLP module, but the results were slightly worse than the ones we obtained in the end, as it can be seen there.
- [find_best_models_with_automl.ipynb](./find_best_model_with_automl.ipynb): uses [auto-sklearn](https://automl.github.io/auto-sklearn/master/) to try to find the best model for the dataset. The results were good, but the final models were too large (from hundreds of MB to 3Gb in size). Because we found another model with the exact same metrics, we opted to use the smaller one. Training with AutoML takes a long time (we configured it to use 2 hours)
- [experiment_different_models.ipynb](./experiment_different_models.ipynb): tests different models (DecisionTreeClassifier, RandomForestClassifier, AdaBoostClassifier, GradientBoostingClassifier, XGBClassifier, CatBoostClassifier and LinearSVC). This is the notebook where the best model was found: LinearSVC with CountVectorizer.
5. After these notebooks were tested, we concluded that LinearSVC is the best model, as described by the metrics above.