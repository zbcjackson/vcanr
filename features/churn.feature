Feature: Churn analytics

  Scenario: Add and modify files
    Given there is a repo with commits
      | Add   | Modify      | Delete |
      | a.txt |             |        |
      | b.txt | a.txt       |        |
      | c.txt | a.txt b.txt |        |
    When churn analyze the repo
    Then the report shows
      | file  | churn |
      | a.txt | 3     |
      | b.txt | 2     |
      | c.txt | 1     |