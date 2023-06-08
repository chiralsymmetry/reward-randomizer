// sqflite implementation of the storage service

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reward_randomizer/services/storage.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:reward_randomizer/models/activity.dart';

const _databaseName = "activities.db";
const _actTbl = "activities";
const _actId = "id";
const _actIconCodePoint = "icon_code_point";
const _actIconFontFamily = "icon_font_family";
const _actIconFontPackage = "icon_font_package";
const _actLabel = "label";
const _actQuestion = "question";
const _actAnswer = "answer";
const _actReciprocal = "reciprocal";
const _rwdTbl = "rewards";
const _rwdId = "id";
const _rwdActId = "activity_id";
const _rwdRwd = "reward";

class StorageSqlite implements Storage {
  Future<sql.Database> _getDatabase() async {
    // await sql.deleteDatabase(
    //     path.join(await sql.getDatabasesPath(), _databaseName));
    final db = await sql.openDatabase(
      path.join(await sql.getDatabasesPath(), _databaseName),
      version: 1,
      onConfigure: (db) {
        db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (sql.Database db, int version) {
        db.execute('''
CREATE TABLE IF NOT EXISTS "$_actTbl" (
	"$_actId"	TEXT NOT NULL UNIQUE,
	"$_actIconCodePoint" INTEGER NOT NULL,
  "$_actIconFontFamily" TEXT NOT NULL,
  "$_actIconFontPackage" TEXT NOT NULL,
	"$_actLabel"	TEXT NOT NULL,
	"$_actQuestion"	TEXT NOT NULL,
	"$_actAnswer"	TEXT NOT NULL,
	"$_actReciprocal"	INTEGER NOT NULL,
	PRIMARY KEY("$_actId")
);
          ''');
        db.execute('''
CREATE TABLE IF NOT EXISTS "$_rwdTbl" (
	"$_rwdId"	INTEGER NOT NULL UNIQUE,
	"$_rwdActId"	TEXT NOT NULL,
	"$_rwdRwd"	TEXT NOT NULL,
	PRIMARY KEY("$_rwdId" AUTOINCREMENT),
	FOREIGN KEY("$_rwdActId") REFERENCES "$_actTbl"("$_actId") ON DELETE CASCADE
);
          ''');
      },
    );
    return db;
  }

  @override
  Future<List<Activity>> loadActivities() async {
    final db = await _getDatabase();
    final Map<String, List<String>> rewards = {};
    final rewardsRows = await db.query(
      _rwdTbl,
      columns: [_rwdActId, _rwdRwd],
    );
    for (final rewardRow in rewardsRows) {
      if (!rewards.containsKey(rewardRow[_rwdActId])) {
        rewards[rewardRow[_rwdActId] as String] = [];
      }
      rewards[rewardRow[_rwdActId]]!.add(rewardRow[_rwdRwd] as String);
    }
    final activities = <Activity>[];
    final activitiesRows = await db.query(_actTbl);
    for (final activityRow in activitiesRows) {
      activities.add(
        Activity(
          id: activityRow[_actId] as String,
          icon: FaIcon(
            IconData(activityRow[_actIconCodePoint] as int,
                fontFamily: activityRow[_actIconFontFamily] as String,
                fontPackage: activityRow[_actIconFontPackage] as String),
          ),
          label: activityRow[_actLabel] as String,
          question: activityRow[_actQuestion] as String,
          answer: activityRow[_actAnswer] as String,
          reciprocal: activityRow[_actReciprocal] as int,
          rewards: rewards[activityRow[_actId]] ?? [],
        ),
      );
    }
    return activities;
  }

  @override
  Future<void> addActivity(Activity activity) async {
    final db = await _getDatabase();
    db.insert(
      _actTbl,
      {
        _actId: activity.id,
        _actIconCodePoint: activity.icon.icon!.codePoint,
        _actIconFontFamily: activity.icon.icon!.fontFamily,
        _actIconFontPackage: activity.icon.icon!.fontPackage,
        _actLabel: activity.label,
        _actQuestion: activity.question,
        _actAnswer: activity.answer,
        _actReciprocal: activity.reciprocal,
      },
    );
    for (final reward in activity.rewards) {
      db.insert(
        _rwdTbl,
        {
          _rwdActId: activity.id,
          _rwdRwd: reward,
        },
      );
    }
  }

  @override
  Future<void> removeActivity(Activity activity) async {
    final db = await _getDatabase();
    await db.delete(
      _rwdTbl,
      where: "$_rwdActId = ?",
      whereArgs: [activity.id],
    );
    await db.delete(
      _actTbl,
      where: "$_actId = ?",
      whereArgs: [activity.id],
    );
  }

  @override
  Future<void> updateActivity(Activity activity) async {
    final db = await _getDatabase();
    await db.delete(
      _rwdTbl,
      where: "$_rwdActId = ?",
      whereArgs: [activity.id],
    );
    for (final reward in activity.rewards) {
      db.insert(
        _rwdTbl,
        {
          _rwdActId: activity.id,
          _rwdRwd: reward,
        },
      );
    }
    await db.update(
      _actTbl,
      {
        _actIconCodePoint: activity.icon.icon!.codePoint,
        _actIconFontFamily: activity.icon.icon!.fontFamily,
        _actIconFontPackage: activity.icon.icon!.fontPackage,
        _actLabel: activity.label,
        _actQuestion: activity.question,
        _actAnswer: activity.answer,
        _actReciprocal: activity.reciprocal,
      },
      where: "$_actId = ?",
      whereArgs: [activity.id],
    );
  }
}
