// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: camel_case_types

import 'dart:typed_data';

import 'package:objectbox/flatbuffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart';

import 'models/database/points.dart';
import 'models/database/projects.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <ModelEntity>[
  ModelEntity(
      id: const IdUid(1, 2616335250161436945),
      name: 'DBPoint',
      lastPropertyId: const IdUid(7, 3861221559089906472),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 4671260849957617246),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 9180502074334386597),
            name: 'x',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 7624336343299356896),
            name: 'y',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 6731745563611635568),
            name: 'z',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 5473818131308570653),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 4445900996410743654),
            name: 'projectId',
            type: 11,
            flags: 520,
            indexId: const IdUid(1, 6480092581063713950),
            relationTarget: 'Project'),
        ModelProperty(
            id: const IdUid(7, 3861221559089906472),
            name: 'rank',
            type: 6,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(2, 7787463398407208069),
      name: 'Project',
      lastPropertyId: const IdUid(3, 8744909655619673092),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 6163662803193877868),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 7314087577693876432),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 8744909655619673092),
            name: 'creation',
            type: 10,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[
        ModelBacklink(name: 'points', srcEntity: 'DBPoint', srcField: '')
      ])
];

/// ObjectBox model definition, pass it to [Store] - Store(getObjectBoxModel())
ModelDefinition getObjectBoxModel() {
  final model = ModelInfo(
      entities: _entities,
      lastEntityId: const IdUid(2, 7787463398407208069),
      lastIndexId: const IdUid(1, 6480092581063713950),
      lastRelationId: const IdUid(0, 0),
      lastSequenceId: const IdUid(0, 0),
      retiredEntityUids: const [],
      retiredIndexUids: const [],
      retiredPropertyUids: const [],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, EntityDefinition>{
    DBPoint: EntityDefinition<DBPoint>(
        model: _entities[0],
        toOneRelations: (DBPoint object) => [object.project],
        toManyRelations: (DBPoint object) => {},
        getId: (DBPoint object) => object.id,
        setId: (DBPoint object, int id) {
          object.id = id;
        },
        objectToFB: (DBPoint object, fb.Builder fbb) {
          final nameOffset = fbb.writeString(object.name);
          fbb.startTable(8);
          fbb.addInt64(0, object.id);
          fbb.addFloat64(1, object.x);
          fbb.addFloat64(2, object.y);
          fbb.addFloat64(3, object.z);
          fbb.addOffset(4, nameOffset);
          fbb.addInt64(5, object.project.targetId);
          fbb.addInt64(6, object.rank);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = DBPoint(
              x: const fb.Float64Reader().vTableGet(buffer, rootOffset, 6, 0),
              y: const fb.Float64Reader().vTableGet(buffer, rootOffset, 8, 0),
              z: const fb.Float64Reader().vTableGet(buffer, rootOffset, 10, 0),
              name:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 12, ''),
              rank: const fb.Int64Reader().vTableGet(buffer, rootOffset, 16, 0),
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0));
          object.project.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 14, 0);
          object.project.attach(store);
          return object;
        }),
    Project: EntityDefinition<Project>(
        model: _entities[1],
        toOneRelations: (Project object) => [],
        toManyRelations: (Project object) => {
              RelInfo<DBPoint>.toOneBacklink(
                      6, object.id, (DBPoint srcObject) => srcObject.project):
                  object.points
            },
        getId: (Project object) => object.id,
        setId: (Project object, int id) {
          object.id = id;
        },
        objectToFB: (Project object, fb.Builder fbb) {
          final nameOffset = fbb.writeString(object.name);
          fbb.startTable(4);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, nameOffset);
          fbb.addInt64(2, object.creation.millisecondsSinceEpoch);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = Project(
              const fb.StringReader().vTableGet(buffer, rootOffset, 6, ''))
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0)
            ..creation = DateTime.fromMillisecondsSinceEpoch(
                const fb.Int64Reader().vTableGet(buffer, rootOffset, 8, 0));
          InternalToManyAccess.setRelInfo(
              object.points,
              store,
              RelInfo<DBPoint>.toOneBacklink(
                  6, object.id, (DBPoint srcObject) => srcObject.project),
              store.box<Project>());
          return object;
        })
  };

  return ModelDefinition(model, bindings);
}

/// [DBPoint] entity fields to define ObjectBox queries.
class DBPoint_ {
  /// see [DBPoint.id]
  static final id = QueryIntegerProperty<DBPoint>(_entities[0].properties[0]);

  /// see [DBPoint.x]
  static final x = QueryDoubleProperty<DBPoint>(_entities[0].properties[1]);

  /// see [DBPoint.y]
  static final y = QueryDoubleProperty<DBPoint>(_entities[0].properties[2]);

  /// see [DBPoint.z]
  static final z = QueryDoubleProperty<DBPoint>(_entities[0].properties[3]);

  /// see [DBPoint.name]
  static final name = QueryStringProperty<DBPoint>(_entities[0].properties[4]);

  /// see [DBPoint.project]
  static final project =
      QueryRelationProperty<DBPoint, Project>(_entities[0].properties[5]);

  /// see [DBPoint.rank]
  static final rank = QueryIntegerProperty<DBPoint>(_entities[0].properties[6]);
}

/// [Project] entity fields to define ObjectBox queries.
class Project_ {
  /// see [Project.id]
  static final id = QueryIntegerProperty<Project>(_entities[1].properties[0]);

  /// see [Project.name]
  static final name = QueryStringProperty<Project>(_entities[1].properties[1]);

  /// see [Project.creation]
  static final creation =
      QueryIntegerProperty<Project>(_entities[1].properties[2]);
}
