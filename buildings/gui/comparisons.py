from buildings.sql import select_statements as select


def compare_outlines(self, commit_status):
    """
        Method called to compare outlines of current unprocessed dataset
    """
    self.db.open_cursor()

    sql = 'SELECT shape FROM buildings_reference.capture_source_area WHERE area_title = %s;'
    result = self.db.execute_no_commit(sql, (self.cmb_capture_source_area.currentText(),))
    hull = result.fetchall()[0][0]

    result = self.db.execute_no_commit(select.building_outlines, (hull,))
    results = result.fetchall()

    if len(results) > 0:
        # intersecting outlines exist
        for ls in results:
            life_span_check = self.db.execute_no_commit(
                select.building_outlines_end_lifespan_by_id, (ls[0],))
            life_span_check = life_span_check.fetchall()[0][0]
            if life_span_check is None:
                # If the outline is still 'active'
                result = self.db.execute_no_commit(
                    select.existing_subset_extracts_by_building_outlineID, (ls[0],))
                result = result.fetchall()
                if len(result) == 0:
                    # insert new outline into existing subset extracts
                    sql = 'SELECT buildings_bulk_load.existing_subset_extracts_insert(%s, %s, %s);'
                    result = self.db.execute_no_commit(
                        sql, (ls[0], self.current_dataset, ls[10]))
                else:
                    # update supplied dataset id of existing outline
                    sql = 'SELECT buildings_bulk_load.existing_subset_extracts_update_supplied_dataset(%s, %s);'
                    self.db.execute_no_commit(
                        sql, (self.current_dataset, ls[0]))

    # run comparisons function
    sql = 'SELECT buildings_bulk_load.compare_building_outlines(%s);'
    self.db.execute_no_commit(sql, (self.current_dataset,))
    if commit_status:
        self.db.commit_open_cursor()
