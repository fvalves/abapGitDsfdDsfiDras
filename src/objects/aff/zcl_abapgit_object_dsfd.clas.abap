class zcl_abapgit_object_dsfd definition
  public
  inheriting from zcl_abapgit_object_common_aff
  final
  create public .

  public section.
    methods zif_abapgit_object~changed_by            redefinition.
    methods zif_abapgit_object~get_deserialize_steps redefinition.
  protected section.
    methods get_additional_extensions                redefinition.
  private section.
endclass.



class zcl_abapgit_object_dsfd implementation.
  method zif_abapgit_object~changed_by.

    data: lo_dsfd_handler          type ref to object,
          lo_dsfd_source_container type ref to object,
          lv_object_key            type seu_objkey,
          lx_error                 type ref to cx_root.

    try.
        lv_object_key = ms_item-obj_name.
        call method ('CL_DSFD_AFF_OBJECT_HANDLER')=>('GET_DDIC_HANDLER')
          exporting
            object_key = lv_object_key
          receiving
            handler    = lo_dsfd_handler.

        call method lo_dsfd_handler->('GET_SOURCE_CONTAINER')
          exporting
            iv_as4local = 'A'
          receiving
            ro_result   = lo_dsfd_source_container.

        call method lo_dsfd_source_container->('GET_AS4USER')
          receiving
            rv_as4user = rv_user.

      catch cx_root into lx_error.
        zcx_abapgit_exception=>raise_with_text( lx_error ).
    endtry.
  endmethod.

  method zif_abapgit_object~get_deserialize_steps.
    append zif_abapgit_object=>gc_step_id-ddic to rt_steps.
  endmethod.

  method get_additional_extensions.
    data ls_additional_extension like line of rv_additional_extensions.
    ls_additional_extension-extension = 'acds'.
    call method ('CL_CDS_AFF_FILE_NAME_MAPPER')=>for_cds
      receiving
        result = ls_additional_extension-file_name_mapper.
    append ls_additional_extension to rv_additional_extensions.
  endmethod.
endclass.
