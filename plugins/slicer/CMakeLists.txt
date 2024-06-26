# Copyright (c) MONAI Consortium
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#     http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

cmake_minimum_required(VERSION 3.13.4)

project(MONAILabel)

#-----------------------------------------------------------------------------
# Extension meta-information
set(EXTENSION_HOMEPAGE "https://github.com/Project-MONAI/MONAILabel/tree/main/plugins/slicer")
set(EXTENSION_CATEGORY "Active Learning")
set(EXTENSION_CONTRIBUTORS "Sachidanand Alle (NVIDIA), Andres Diaz-Pinto (KCL), Alvin Ihsani (NVIDIA), Fernando Perez-Garcia (UCL/KCL)")
set(EXTENSION_DESCRIPTION "This extension offers Active Learning solution developed under project MONAILabel (Powered by the NVIDIA, KCL).")
set(EXTENSION_ICONURL "https://github.com/Project-MONAI/MONAILabel/raw/main/plugins/slicer/MONAILabel/Resources/Icons/MONAILabel.png")
set(EXTENSION_SCREENSHOTURLS "https://github.com/Project-MONAI/MONAILabel/raw/main/plugins/slicer/MONAILabel/Screenshots/1.png https://github.com/Project-MONAI/MONAILabel/raw/main/plugins/slicer/MONAILabel/Screenshots/2.png https://github.com/Project-MONAI/MONAILabel/raw/main/plugins/slicer/MONAILabel/Screenshots/3.png")
set(EXTENSION_DEPENDS "NA") # Specified as a list or "NA" if no dependencies

#-----------------------------------------------------------------------------
# Extension dependencies
find_package(Slicer REQUIRED)
include(${Slicer_USE_FILE})

#-----------------------------------------------------------------------------
# Extension modules
add_subdirectory(MONAILabel)
add_subdirectory(MONAILabelReviewer)
## NEXT_MODULE

#-----------------------------------------------------------------------------
include(${Slicer_EXTENSION_GENERATE_CONFIG})
include(${Slicer_EXTENSION_CPACK})
