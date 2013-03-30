/*
 *  This file is part of the command-line tool sosicon.
 *  Copyright (C) 2012  Espen Andersen
 *
 *  This is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
#ifndef __CONVERTER_SOSI2SHP_H__
#define __CONVERTER_SOSI2SHP_H__

#include <iostream>
#include <fstream>
#include <vector>
#include "interface/i_converter.h"
#include "interface/i_sosi_element.h"
#include "interface/i_shapefile_shp_part.h"
#include "interface/i_shapefile_shx_part.h"
#include "interface/i_shapefile_dbf_part.h"
#include "command_line.h"
#include "string_utils.h"
#include "parser.h"
#include "shape/shapefile.h"

namespace sosicon {

    /*!
        \addtogroup converters
        Collection of sosicon::IConverter implementations for handling and generating file output.
        Different command-line arguments will employ different converters. The factory class
        sosicon::Factory is responsible for creating correct IConverter instance. The following
        arguments are currently interpreted:
        - -2tsv: sosicon::ConverterSosi2tsv TSV file conversion
        - -2shp: sosicon::ConverterSosi2shp Shape file conversion
        @{
    */
    //! SOSI to ESRI Shape converter
    /*!
        If command-line parameter -2shp is specified, this converter will handle the output
        generation. Produces an ESRI Shape-file from SOSI source.
     */
    class ConverterSosi2shp : public IConverter {

        //! Command line wrapper
        CommandLine mCmd;

        //! Shapefile wrapper
        shape::Shapefile mShapefile;
        
        virtual ~ConverterSosi2shp();

    public:

        //! Constructor
        ConverterSosi2shp();

        //! Initialize converter
        /*!
            Implementation details in sosicon::IConverter::init()
            \sa sosicon::IConverter::init()
         */
        virtual void init( CommandLine cmd );

        //! Start conversion
        /*!
            Implementation details in sosicon::IConverter::run()
            \sa sosicon::IConverter::run()
         */
        virtual void run();

    }; // class ConverterSosi2shp
   /*! @} end group converters */
    
}; // namespace sosicon

#endif