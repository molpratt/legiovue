process PYSAMSTATS {
    tag "$meta.id"
    label 'process_low'

    conda "bioconda::pysamstats=1.1.2"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/pysamstats:1.1.2--py39he47c912_12':
        'biocontainers/pysamstats:1.1.2--py39he47c912_12' }"

    input:
    tuple val(meta), path(bam), path(bai)
    val type

    output:
    tuple val(meta), path("${meta.id}.${type}.stats.tsv"), emit: tsv
    path "versions.yml", emit: versions

    script:
    """
    pysamstats \\
        --type $type \\
        -d $bam \\
        > ${meta.id}.${type}.stats.tsv

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        pysamstats: \$(pysamstats -h | tail -n 2 | grep -Eo ": \\S+" | cut -d" " -f2)
    END_VERSIONS
    """
}
