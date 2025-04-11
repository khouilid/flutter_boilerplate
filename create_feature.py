#!/usr/bin/env python3
"""
Feature Generator for Flutter Boilerplate App

This script creates a new feature with the clean architecture structure
as defined in the project architecture.

Usage:
    python create_feature.py <feature_name>

Example:
    python create_feature.py payment
    
This will create a payment feature with all necessary files and folders.
"""

import os
import sys
import re

# Helper function to convert strings to different cases
def to_snake_case(name):
    """Convert a string to snake_case."""
    s1 = re.sub('(.)([A-Z][a-z]+)', r'\1_\2', name)
    return re.sub('([a-z0-9])([A-Z])', r'\1_\2', s1).lower()

def to_pascal_case(name):
    """Convert a string to PascalCase."""
    # First convert to snake_case if it's not already
    snake_case = to_snake_case(name)
    # Then convert to PascalCase
    return ''.join(word.capitalize() for word in snake_case.split('_'))

def create_file(file_path, content):
    """Create a file with the given content."""
    # Create directory if it doesn't exist
    os.makedirs(os.path.dirname(file_path), exist_ok=True)
    
    # Write content to file
    with open(file_path, 'w') as f:
        f.write(content)
    
    print(f"Created: {file_path}")

def main():
    # Check if feature name is provided
    if len(sys.argv) != 2:
        print("Usage: python create_feature.py <feature_name>")
        sys.exit(1)
    
    # Get feature name and convert to different cases
    feature_name = sys.argv[1]
    snake_case = to_snake_case(feature_name)
    pascal_case = to_pascal_case(feature_name)
    
    # Define the base directory for the feature
    feature_dir = f"lib/features/{snake_case}"
    
    # Create the main feature directories
    directories = [
        f"{feature_dir}/domain",
        f"{feature_dir}/application",
        f"{feature_dir}/infrastructure/repositories",
        f"{feature_dir}/infrastructure/DTO",
        f"{feature_dir}/infrastructure/services",
        f"{feature_dir}/presentation",
        f"{feature_dir}/presentation/widgets",
        f"{feature_dir}/providers",
    ]
    
    for directory in directories:
        os.makedirs(directory, exist_ok=True)
        print(f"Created directory: {directory}")
    
    # Create domain layer files
    
    # Entity
    entity_file = f"{feature_dir}/domain/{snake_case}.dart"
    entity_content = f"""import 'package:freezed_annotation/freezed_annotation.dart';

part '{snake_case}.freezed.dart';
part '{snake_case}.g.dart';

@freezed
class {pascal_case} with _${pascal_case} {{
  const factory {pascal_case}({{
    required String id,
    // Add your entity properties here
  }}) = _{pascal_case};
  
  factory {pascal_case}.fromJson(Map<String, dynamic> json) => 
      _{pascal_case}FromJson(json);
}}
"""
    create_file(entity_file, entity_content)
    
    # Create application layer files
    
    # State
    state_file = f"{feature_dir}/application/{snake_case}_state.dart"
    state_content = f"""import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../config/domain/failure.dart';

part '{snake_case}_state.freezed.dart';

@freezed
class {pascal_case}State with _${pascal_case}State {{
  const {pascal_case}State._();
  const factory {pascal_case}State.initial() = _Initial;
  const factory {pascal_case}State.loading() = _Loading;
  const factory {pascal_case}State.success() = _Success;
  const factory {pascal_case}State.error(Failure failure) = _Error;
}}
"""
    create_file(state_file, state_content)
    
    # Application notifier
    application_file = f"{feature_dir}/application/{snake_case}_application.dart"
    application_content = f"""import 'package:boilerplate_app/config/domain/failure.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/{snake_case}.dart';
import '../infrastructure/repositories/{snake_case}_repository.dart';
import '{snake_case}_state.dart';

class {pascal_case}ApplicationNotifier extends StateNotifier<{pascal_case}State> {{
  final {pascal_case}Repository _repository;
  
  {pascal_case}ApplicationNotifier(this._repository) : super(const {pascal_case}State.initial());
  
  Future<void> getAll() async {{
    state = const {pascal_case}State.loading();
    
    final result = await _repository.getAll();
    
    result.fold(
      (failure) => state = {pascal_case}State.error(failure),
      (_) => state = const {pascal_case}State.success(),
    );
  }}

  // Add more methods as needed
}}
"""
    create_file(application_file, application_content)
    
    # Create infrastructure layer files
    
    # DTO
    dto_file = f"{feature_dir}/infrastructure/DTO/{snake_case}_dto.dart"
    dto_content = f"""import 'package:boilerplate_app/features/{snake_case}/domain/{snake_case}.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part '{snake_case}_dto.freezed.dart';
part '{snake_case}_dto.g.dart';

@freezed
class {pascal_case}DTO with _${pascal_case}DTO {{
  const {pascal_case}DTO._();
  
  const factory {pascal_case}DTO({{
    required String id,
    // Add DTO properties here
  }}) = _{pascal_case}DTO;
  
  factory {pascal_case}DTO.fromJson(Map<String, dynamic> json) => 
      _{pascal_case}DTOFromJson(json);
  
  factory {pascal_case}DTO.fromDomain({pascal_case} domain) {{
    return {pascal_case}DTO(
      id: domain.id,
      // Map other properties
    );
  }}
  
  {pascal_case} toDomain() {{
    return {pascal_case}(
      id: id,
      // Map other properties
    );
  }}
}}

@freezed
class {pascal_case}RequestDTO with _${pascal_case}RequestDTO {{
  const factory {pascal_case}RequestDTO({{
    required {pascal_case}DTO {snake_case},
    // Add any other request parameters here
  }}) = _{pascal_case}RequestDTO;
  
  factory {pascal_case}RequestDTO.fromJson(Map<String, dynamic> json) => 
      _{pascal_case}RequestDTOFromJson(json);
}}
"""
    create_file(dto_file, dto_content)
    
    # Service
    service_file = f"{feature_dir}/infrastructure/services/{snake_case}_api_service.dart"
    service_content = f"""import 'package:boilerplate_app/config/providers/network_provider.dart';
import 'package:boilerplate_app/features/{snake_case}/infrastructure/DTO/{snake_case}_dto.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '{snake_case}_api_service.g.dart';

@Riverpod()
class {pascal_case}ApiService extends _${pascal_case}ApiService {{
  late Dio dio;

  @override
  Future<void> build() async {{
    dio = ref.watch(dioProvider);
  }}

  Future<List<{pascal_case}DTO>> getAll() async {{
    // Implement API call to get all items
    return [];
  }}

  Future<{pascal_case}DTO> getById(String id) async {{
    // Implement API call to get item by ID
    return {pascal_case}DTO(id: id);
  }}
  
  Future<{pascal_case}DTO> create({pascal_case}RequestDTO request) async {{
    // Implement API call to create item
    return request.{snake_case};
  }}
}}
"""
    create_file(service_file, service_content)
    
    # Repository
    repository_file = f"{feature_dir}/infrastructure/repositories/{snake_case}_repository.dart"
    repository_content = f"""import 'dart:async';
import 'package:boilerplate_app/config/domain/failure.dart';
import 'package:boilerplate_app/config/infrastructure/helpers/repository_helper.dart';
import 'package:boilerplate_app/features/{snake_case}/domain/{snake_case}.dart';
import 'package:boilerplate_app/features/{snake_case}/infrastructure/services/{snake_case}_api_service.dart';
import 'package:boilerplate_app/features/{snake_case}/infrastructure/DTO/{snake_case}_dto.dart';
import 'package:dartz/dartz.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '{snake_case}_repository.g.dart';

@Riverpod()
class {pascal_case}Repository extends _${pascal_case}Repository with RepositoryHelper {{
  late {pascal_case}ApiService _apiService;

  @override
  Future<void> build() async {{
    _apiService = ref.read({snake_case}ApiServiceProvider.notifier);
  }}

  Future<List<{pascal_case}>> getItems() async {{
    // Return empty list for now
    return [];
  }}

  FutureEitherFailureOr<List<{pascal_case}>> getAll() async {{
    try {{
      final dtos = await _apiService.getAll();
      final items = dtos.map((dto) => dto.toDomain()).toList();
      return right(items);
    }} on Exception catch (e) {{
      return left(Failure.network(e.toString()));
    }}
  }}
  
  FutureEitherFailureOr<{pascal_case}> getById(String id) async {{
    return handleData(
      _apiService.getById(id),
      (data) async => data.toDomain(),
    );
  }}
  
  FutureEitherFailureOr<{pascal_case}> create({pascal_case} item) async {{
    final dto = {pascal_case}DTO.fromDomain(item);
    final request = {pascal_case}RequestDTO({snake_case}: dto);
    
    return handleData(
      _apiService.create(request),
      (data) async => data.toDomain(),
    );
  }}
}}
"""
    create_file(repository_file, repository_content)
    
    # Create providers
    providers_file = f"{feature_dir}/providers/{snake_case}_provider.dart"
    providers_content = f"""import 'package:boilerplate_app/features/{snake_case}/application/{snake_case}_application.dart';
import 'package:boilerplate_app/features/{snake_case}/application/{snake_case}_state.dart';
import 'package:boilerplate_app/features/{snake_case}/infrastructure/repositories/{snake_case}_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final {snake_case}ApplicationProvider =
    StateNotifierProvider<{pascal_case}ApplicationNotifier, {pascal_case}State>((ref) {{
  final repository = ref.watch({snake_case}RepositoryProvider.notifier);
  return {pascal_case}ApplicationNotifier(repository);
}});
"""
    create_file(providers_file, providers_content)
    
    # Create presentation layer files
    
    # Screen/Page
    page_file = f"{feature_dir}/presentation/{snake_case}_page.dart"
    page_content = f"""import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/{snake_case}_provider.dart';
import 'widgets/{snake_case}_list_item.dart';

class {pascal_case}Page extends ConsumerWidget {{
  const {pascal_case}Page({{Key? key}}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {{
    final state = ref.watch({snake_case}ApplicationProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('{pascal_case}'),
      ),
      body: state.when(
        initial: () => const Center(child: Text('Press the button to load data')),
        loading: () => const Center(child: CircularProgressIndicator()),
        success: () => const Center(child: Text('Data loaded successfully')),
        error: (failure) => Center(
          child: Text('Error: ${{failure.message ?? "Unknown error"}}'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {{
          ref.read({snake_case}ApplicationProvider.notifier).getAll();
        }},
        child: const Icon(Icons.refresh),
      ),
    );
  }}
}}
"""
    create_file(page_file, page_content)
    
    # Widget components
    widget_file = f"{feature_dir}/presentation/widgets/{snake_case}_list_item.dart"
    widget_content = f"""import 'package:flutter/material.dart';
import '../../domain/{snake_case}.dart';

class {pascal_case}ListItem extends StatelessWidget {{
  final {pascal_case} item;
  final Function()? onTap;
  
  const {pascal_case}ListItem({{
    Key? key,
    required this.item,
    this.onTap,
  }}) : super(key: key);

  @override
  Widget build(BuildContext context) {{
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        title: Text(item.id),
        // Add more UI elements based on your entity properties
        onTap: onTap,
      ),
    );
  }}
}}
"""
    create_file(widget_file, widget_content)
    
    print(f"\nFeature '{pascal_case}' created successfully!")
    print(f"Don't forget to run 'flutter pub run build_runner build --delete-conflicting-outputs' to generate freezed files.")
    print("Make sure you have the following dependencies in your pubspec.yaml:")
    print("""
dependencies:
  riverpod_annotation: ^2.0.0
  
dev_dependencies:
  riverpod_generator: ^2.0.0
""")

if __name__ == "__main__":
    main()
