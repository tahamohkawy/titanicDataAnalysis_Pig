--DATA SET DESCRIPTION
        --Column 1 : PassengerId
        --Column 2 : Survived  (survived=0 & died=1)
        --Column 3 : Pclass
        --Column 4 : Name
        --Column 5 : Sex
        --Column 6 : Age
        --Column 7 : SibSp
        --Column 8 : Parch
        --Column 9 : Ticket
        --Column 10 : Fare
        --Column 11 : Cabin
        --Column 12 : Embarked

--Sample
--1,0,3,"Braund Mr. Owen Harris",male,22,1,0,A/5 21171,7.25,,S,

--Titanic Data Analysis

dataset = LOAD '/user/demo/taha/titanic' using PigStorage(',')
as (PassengerId:int, Survived:chararray, Pclass:int,Name:chararray, Sex:chararray, Age:int, SibSp:int, Parch:int, Ticket:chararray, Fare:float, Cabin:chararray, Embarked:chararray );

DUMP dataset;

--Number of males and females
gender_grouped = GROUP dataset BY Sex;

gender = FOREACH gender_grouped GENERATE (group, COUNT(dataset));

DUMP gender;

--Number of dead and live

grouped_status = GROUP dataset BY Survived;

status = FOREACH grouped_status GENERATE (CASE group
                                            WHEN '0' THEN 'SURVIVED'
                                            WHEN '1' THEN 'DEAD'
                                            ELSE group
                                          END ) , COUNT(dataset);

DUMP status;

--Number of dead and live by sex

grouped_gender_status = GROUP dataset BY (Sex, Survived);

gender_status = FOREACH grouped_gender_status GENERATE (CASE group.Survived
                                                        WHEN '0' THEN 'SURVIVED'
                                                        WHEN '1' THEN 'DEAD'
                                                        END) as Status, group.Sex, COUNT(dataset);

DUMP gender_status;


--Number of people in each class

grouped_class = GROUP dataset BY Pclass;

passengers_in_class = FOREACH grouped_class GENERATE group, COUNT(dataset);

DUMP passengers_in_class;


--Number of dead and live in each class
grouped_status_class = GROUP dataset BY (Survived,Pclass);

status_class = FOREACH grouped_status_class GENERATE (CASE group.Survived
                                                      WHEN '0' THEN 'SURVIVED'
                                                      WHEN '1' THEN 'DEAD'
                                                      END ) as Status, group.Pclass,COUNT(dataset);
DUMP status_class;


--Number of dead and live by sex in each class

grouped_status_sex_class = GROUP dataset BY (Survived, Sex, Pclass);
status_sex_class = FOREACH grouped_status_sex_class GENERATE (CASE group.Survived
                                                              WHEN '0' THEN 'SURVIVED'
                                                              WHEN '1' THEN 'DEAD'
                                                              END ) as Status, group.Sex, group.Pclass,COUNT(dataset);

DUMP status_sex_class;
