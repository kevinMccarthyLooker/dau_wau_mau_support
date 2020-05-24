# Readme



<details>
<summary><span style="font-size:1.25em">(IF YOU ARE READING THIS ON YOUR INSTANCE, STEP 1 IS ALREADY COMPLETED)<br>Step 1 - Add the block reference to your manifest.lkml file...</span>
</summary>

<pre><code>
remote_dependency: dau_wau_mau_support__remote_dependency {
  url: "git://github.com/kevinMccarthyLooker/dau_wau_mau_support.git"
  ref: "master"
}
</code></pre>
</details>

<details>
<summary><span style="font-size:1.25em">
Step 2 - Add the block to your explore...</span>
</summary>

  <details><summary><span style="font-size:1em">
  Step 2a - Paste the following lookml above your explore definition...</span>
  </summary>
  <pre><code>
include: "//dau_wau_mau_support__remote_dependency/dau_wau_mau_support.view"
view: +dau_wau_mau_support {
  dimension: date_to_use__input_field {sql:${UPDATE__VIEW_NAME.UPDATE_ME__DATE_FIELD};;}
  dimension: user_id__input_field {sql:${UPDATE__VIEW_NAME.UPDATE_ME__UNIQUE_ID};;}
}
  </code></pre>
  </details>

<li><span style="font-size:1em">Step 2b - Update the UPDATE references in the code you pasted to point to existing fields in your explore</span></li>

<li><span style="font-size:1em">Step 2c - Set your explore to extend the block <code>extends: [dau_wau_mau_support]</code></span></li>

</details>
