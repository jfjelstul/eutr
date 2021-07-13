# eutr

An `R` package for the European Union Technical Regulations (EUTR) Database. The EUTR database is part of the European Union Compliance Project (EUCP), which also includes the [European Union Infringement Procedure (EUIP) Database](https://github.com/jfjelstul/euip) and the [European Union State Aid (EUSA) Database](https://github.com/jfjelstul/eusa). The EUCP is introduced in the working paper "Legal Compliance in the European Union: Institutional Procedures and Strategic Enforcement Behavior" by Joshua C. Fjelstul. 

The EUTR Database includes 15 datasets on the EU technical regulations procedure (also known as the 2015/1535 procedure after the directive that most recently revised the procedure), including data on proposed technical regulations notified to the Commission by member states, comments filed by third-party member states and the Commission, and detailed opinions filed by third-party member states and the Commission. It also includes time-series and cross-sectional time-series on notifications and time-series, cross-sectional time-series, directed dyad-year, and network data on comments and detailed opinions.

## Installation

You can install the latest development version from GitHub:

```r
# install.packages("devtools")
devtools::install_github("jfjelstul/eutr")
```

## Documentation

The codebook for the database is included as a `tibble` in the package: `eutr::codebook`. The same documentation is also available in the `R` documentation for each dataset. For example, you can see the codebook for the `eutr::notifications` dataset by running `?eutr::notifications`. You can also read the documentation on the [package website](https://jfjelstul.github.io/eutr/).

## Citation

If you use data from the `eutr` package in a project or paper, please cite the `R` package:

> Joshua Fjelstul (2021). eutr: The European Union Technical Regulations (EUTR) Database. R package version 0.1.0.9000.

The `BibTeX` entry for the package is:

```
@Manual{,
  title = {eutr: The European Union Technical Regulations (EUTR) Database},
  author = {Joshua Fjelstul},
  year = {2021},
  note = {R package version 0.1.0.9000},
}
```

## Problems

If you notice an error in the data or a bug in the `R` package, please report the error [here](https://github.com/jfjelstul/eutr/issues).
