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
#include "parser.h"
#pragma warning ( disable: 4244 )

namespace sosicon {

    //! \cond 
    %%{
        machine parseSosiLine;
        write data;
    }%%
    //! \endcond

}

void sosicon::Parser::
parseSosiLine( std::string sosiLine )
{
    int cs = 0;
    const char* s = sosiLine.c_str();
    const char* p = s;
    const char* pe = p + sosiLine.size();
    const char* eof = pe;

    %%{

        action filter_by_objtype {
            if( mCurrentElement && 
                std::find( mObjTypeFilter.begin(),
                           mObjTypeFilter.end(),
                           mCurrentElement->getData( "objtype" ) ) != mObjTypeFilter.end() ) {
                mSosiElementsSelection.push_back( mCurrentElement );
            }           
        }
        
        action resolve_coordinates {
            if( mCurrentElement && mHeadElement && !mHeadElement->getData( "enhet" ).empty() ) {
                float flUnit = 0.0, flNorth = 0.0, flEast = 0.0;
                std::stringstream ssUnit, ssNorth, ssEast;
                ssUnit  << mHeadElement->getData( "enhet" );
                ssNorth << mCurrentElement->getData( "koord_n" );
                ssEast  << mCurrentElement->getData( "koord_o" );
                if( ssUnit.good() && ssNorth.good() && ssEast.good() ) {
                    ssUnit   >> flUnit;
                    ssNorth  >> flNorth;
                    ssEast   >> flEast;
                    flNorth  *= flUnit;
                    flEast   *= flUnit;
                    std::stringstream ssNorth2, ssEast2;
                    ssNorth2.unsetf( std::stringstream::scientific );
                    ssNorth2.setf( std::stringstream::fixed );
                    ssNorth2.precision( 2 );
                    ssEast2.unsetf( std::stringstream::scientific );
                    ssEast2.setf( std::stringstream::fixed );
                    ssEast2.precision( 2 );
                    ssNorth2 << flNorth;
                    ssEast2  << flEast;
                    mCurrentElement->set( "koord_n", ssNorth2.str() );
                    mCurrentElement->set( "koord_o", ssEast2.str() );
                }
            }
        }
        
        action resolve_koordsys {
            if( mCurrentElement ) {
                ::sosicon::sosi::CoordSys c( mCurrentElement->getData( "koordsys" ) );
                mCurrentElement->set( "koordsys_srid",        c.getSrid()        );
                mCurrentElement->set( "koordsys_beskrivelse", c.getDescription() );
                mCurrentElement->set( "koordsys_datum",       c.getDatum()       );
                mCurrentElement->set( "koordsys_projeksjon",  c.getProjection()  );
                mCurrentElement->set( "koordsys_sone",        c.getZone()        );                
            }
        }
        
        action see_address_unit {
            appendElementFieldChar( "adressebruksenhet", ' ' );
        }
        
        action see_address_unit_door_number {
            appendElementFieldChar( "adressebruksenhet_lopenummer", fc );
        }

        action see_address_unit_floor_level {
            appendElementFieldChar( "adressebruksenhet_etasjeplan", fc );
        }

        action see_address_unit_floor_number {
            appendElementFieldChar( "adressebruksenhet_etasjenummer", fc );
        }

        action see_aid {
            appendElementFieldChar( "aid", fc );
        }

        action see_aid_letter {
            appendElementFieldChar( "aid_bokstav", fc );
        }
        
        action see_aid_number {
            appendElementFieldChar( "aid_husnr", fc );
        }
        
        action see_aid_street {
            appendElementFieldChar( "aid_gate", fc );
        }
        
        action see_aid_subnumber {
            appendElementFieldChar( "aid_unr", fc );
        }

        action see_area {
            mCurrentElement = new sosicon::sosi::SosiElementArea();
            mSosiElements.push_back( mCurrentElement );
        }
        
        action see_building_number {
            appendElementFieldChar( "byggnr", fc );
        }

        action see_building_status {
            appendElementFieldChar( "byggstat", fc );
        }

        action see_building_type {
            appendElementFieldChar( "byggtyp_nbr", fc );
        }

        action see_cadastral_unit_cadastre {
            appendElementFieldChar( "matrikkelnummer_gardsnr", fc );
        }

        action see_cadastral_unit_leasehold {
            appendElementFieldChar( "matrikkelnummer_festenr", fc );
        }

        action see_cadastral_unit_municipality {
            appendElementFieldChar( "matrikkelnummer_kommunenr", fc );
        }

        action see_cadastral_unit_property {
            appendElementFieldChar( "matrikkelnummer_bruksnr", fc );
        }

        action see_cadastral_unit_section {
            appendElementFieldChar( "matrikkelnummer_seksjonsnr", fc );
        }

        action see_charset {
            appendElementFieldChar( "tegnsett", fc );
        }

        action see_coord_n {
            appendElementFieldChar( "koord_n", fc );
        }

        action see_coord_o {
            appendElementFieldChar( "koord_o", fc );
        }

        action see_coord_precision {
            appendElementFieldChar( "koord_presisjon", fc );
        }

        action see_coord_sys {
            appendElementFieldChar( "koordsys", fc );
        }

        action see_curve {
            mCurrentElement = new sosicon::sosi::SosiElementCurve();
            mSosiElements.push_back( mCurrentElement );
        }

        action see_filler {
            
        }

        action see_head {
            mCurrentElement = new ::sosicon::sosi::SosiElementHead();
            mHeadElement = mCurrentElement;
        }

        action see_id {
            appendElementFieldChar( "id", fc );
        }

        action see_max_n {
            appendElementFieldChar( "max_n", fc );
        }

        action see_max_o {
            appendElementFieldChar( "max_o", fc );
        }

        action see_min_n {
            appendElementFieldChar( "min_n", fc );
        }

        action see_min_o {
            appendElementFieldChar( "min_o", fc );
        }

        action see_municipality_number {
            appendElementFieldChar( "komm", fc );
        }
        
        action see_n_oe {
            appendElementFieldChar( "n_oe", fc );
        }
        
        action see_objtype {
            appendElementFieldChar( "objtype", fc );
        }

        action see_origo_n {
            appendElementFieldChar( "origo_n", fc );
        }

        action see_origo_o {
            if( mCurrentElement ) {
                mCurrentElement->append( "origo_o", fc );
            }
        }

        action see_point {
            mCurrentElement = new sosicon::sosi::SosiElementPoint();
            mSosiElements.push_back( mCurrentElement );
        }
        
        action see_post_name {
            appendElementFieldChar( "post_sted", fc );
        }
        
        action see_post_number {
            appendElementFieldChar( "post_nr", fc );
        }
        
        action see_product_spec {
            appendElementFieldChar( "produktspek", fc );
        }

        action see_ptema {
            appendElementFieldChar( "ptema", fc );
        }

        action see_ref {
            appendElementFieldChar( "ref", fc );
        }

        action see_ref_list {
            if( "ref" == mCurrentElementField ) {
                appendElementFieldChar( "ref", fc );
            }
        }

        action see_ref_parenthesis_start {
            if( mCurrentElement ) {
                mCurrentElement->set( "ref_invert", "1" );
            }
        }

        action see_ref_parenthesis_end {
            if( mCurrentElement ) {
                mCurrentElement->set( "ref_invert", "0" );
            }
        }

        action see_sosi_version {
            appendElementFieldChar( "sosi_versjon", fc );
        }

        action see_ssr_id {
            appendElementFieldChar( "ssr_id", fc );
        }
        
        action see_ssr_snavn {
            appendElementFieldChar( "ssr_snavn", fc );
        }
        
        action see_ssr_snforek {
            appendElementFieldChar( "ssr_snforek", fc );
        }
        
        action see_ssr_snregdato {
            appendElementFieldChar( "ssr_snregdato", fc );
        }
        
        action see_street_name {
            appendElementFieldChar( "gatenavn", fc );
        }
        
        action see_text {
            mCurrentElement = new sosicon::sosi::SosiElementText();
            mSosiElements.push_back( mCurrentElement );
        }

        action see_unit {
            appendElementFieldChar( "enhet", fc );
        }

        action see_unknown {
            mCurrentElement = 0;
        }
        
        crlf          = ( space* . [\n\r]+ );

        crlfq         = ( space* . [\n\r"]+ );

        digits        = ( [0-9]+ );
        
        digits4       = ( [0-9]{4} );

        float         = ( [0-9]+ . [0-9\.]+ );

        letter        = ( [A-Z] );

        ncrlf         = ( [^\n\r]+ );

        ncrlfq        = ( [^\n\r"]+ );

        spaceq        = ( space . ["]? );

        adressebruk   = ( ( '..ADRESSEBRUKSENHET' )@see_address_unit ) |
                        ( ( '...L' . alnum . 'PENR' ) . space . ( digits )$see_address_unit_door_number ) |
                        ( ( '...ETASJENUMMER' ) . space . ( digits )$see_address_unit_floor_number ) |
                        ( ( '...ETASJEPLAN' ) . space . ( letter )$see_address_unit_floor_level );

        aid           = ( ( '..AID' ) . space+ . ( ( digits )$see_aid_street ) . 
                                        space+ . ( ( digits )$see_aid_number ) .
                                        space+ . ( ( letter )$see_aid_letter ) .
                                        space+ . ( ( digits )$see_aid_subnumber ) );

        byggnr        = ( ( '..BYGGNR' ) . space . ( ( digits )$see_building_number ) );

        byggstat      = ( ( '..BYGGSTAT' ) . spaceq . ( ( ncrlfq )$see_building_status ) . crlfq );

        byggtyp       = ( ( '..BYGGTYP_NBR' ) . space . ( ( digits )$see_building_type ) );

        enhet         = ( ( '...ENHET' ) . space+ . ( ( ncrlf )$see_unit ) . crlf );

        filler        = ( ( ^[!]+ ) . ( crlf )$see_filler );

        flate         = ( ( '.FLATE' )@see_area . space+ . ( [^:]+ )$see_id . ':' );

        gatenavn      = ( ( '..GATENAVN' ) . spaceq . ( ( ncrlfq )$see_street_name ) . crlfq );

        hode          = ( ( '.HODE' )@see_head );

        komm          = ( ( '..KOMM' ) . space . ( digits4 )$see_municipality_number );

        kommentar     = ( '!' . any* );

        koordinater   = ( ( float )$see_coord_n . space+ . ( float )$see_coord_o . crlf@resolve_coordinates . ( space+ . '...KP' . space+ . ( digits )$see_coord_precision )? );

        koordsys      = ( ( '...KOORDSYS' ) . space . ( digits )$see_coord_sys . crlf@resolve_koordsys );

        kurve         = ( ( '.KURVE' )@see_curve . space . ( [^:]+ )$see_id . ':' );

        matrikkel     = ( ( '..MATRIKKELNUMMER' ) . space . ( digits )$see_cadastral_unit_municipality .
                                                    space . ( digits )$see_cadastral_unit_cadastre .
                                                    space . ( digits )$see_cadastral_unit_property .
                                                    space . ( digits )$see_cadastral_unit_leasehold .
                                                    space . ( digits )$see_cadastral_unit_section );

        max_no        = ( ( '...MAX-N' . extend ) . space+ . ( float )$see_max_n . space+ . ( float )$see_max_o . crlf );

        min_no        = ( ( '...MIN-N' . extend ) . space+ . ( float )$see_min_n . space+ . ( float )$see_min_o . crlf );

        n_oe          = ( ( '..NØ' )$see_n_oe . crlf );

        objtype       = ( ( '..OBJTYPE' ) . spaceq . ( ( ncrlfq )$see_objtype ) . crlfq@filter_by_objtype );

        origo_no      = ( ( '...ORIGO-N' . extend ) . space+ . ( float )$see_origo_n . space+ . ( float )$see_origo_o . crlf );

        post          = ( ( ( '..POST' ) . space . ( digits4 )$see_post_number ) .
                                          spaceq . ( ( ( ncrlfq )+ )$see_post_name ) . crlfq );

        produktspek   = ( ( '...PRODUKTSPEK' ) . space . ( ( ncrlf )$see_product_spec ) . crlf );

        ptema         = ( ( '..PTEMA' ) . space . ( digits )$see_ptema );

        punkt         = ( ( '.PUNKT' )@see_point . space . ( [^:]+ )$see_id . ':' );

        ref_list      = ( ( space* . ( [\(]? )$see_ref_parenthesis_start . ( ':' . [^:\)\r\n]+ )$see_ref . ( [\)]? )$see_ref_parenthesis_end )+ . crlf );

        ref           = ( ( '..REF' ) . ref_list );

        sosi_versjon  = ( ( '..SOSI-VERSJON' ) . spaceq . ( ncrlfq )$see_sosi_version );

        ssr_id        = ( ( '...SSR-ID' ) . space . ( digits )$see_ssr_id );

        ssr_snavn      = ( ( '...SNAVN' ) . spaceq . ( ( ncrlfq )$see_ssr_snavn ) . crlfq );

        ssr_snforek   = ( ( '...SSR-FOREK' ) . space . ( ncrlf )$see_ssr_snforek );

        ssr_snregdato = ( ( '...SSR-SNREGDATO' ) . space . ( digits )$see_ssr_snregdato );

        tegnsett      = ( ( '..TEGNSETT' ) . spaceq . ( ( ncrlfq )$see_charset ) . crlfq );

        tekst         = ( ( '.TEKST' )@see_text );

        ukjent        = ( ( '.' . [^.] )@see_unknown ) . extend*;

        main := ( adressebruk    |
                  aid            |
                  byggnr         |
                  byggstat       |
                  byggtyp        |
                  enhet          |
                  filler         |
                  flate          |
                  gatenavn       |
                  hode           |
                  komm           |
                  kommentar      |
                  koordinater    |
                  koordsys       |
                  kurve          |
                  matrikkel      |
                  max_no         |
                  min_no         |
                  n_oe           |
                  objtype        |
                  origo_no       |
                  post           |
                  produktspek    |
                  ptema          |
                  punkt          |
                  ref            |
                  ref_list       |
                  sosi_versjon   |
                  ssr_id         |
                  ssr_snavn      |
                  ssr_snforek    |
                  ssr_snregdato  |
                  tekst          |
                  tegnsett       |
                  ukjent         );

        write init;
        write exec;

    }%%

};